import re

class Story:
    
    def __init__(self, path):
        self.stories, self.initial = self.process_output(path)
        
        for item in self.initial:
            if 'role(protag' in item:
                self.main = item[27:-2]

    def process_output(self, path):
        '''takes path to ASP encoding output,
        returns a list of individual paths,
        each of which is a list of states,
        each of which is a tuple of choice + outcomes,
        and separately returns the initial setting'''
        
        f = open(path)
        raw = f.read().replace('\n','')
        raw = raw.split('State 0')[1:]
        
        token = re.compile("\w+\(.*\)")
        
        for story in range(len(raw)):
            raw[story] = raw[story].split('State')
            
            for state in range(len(raw[story])):
                raw[story][state] = raw[story][state].split(' ')
                raw[story][state] = list(filter(None, raw[story][state]))[1:]
                
                if story == 0 & state == 0:
                    initial = raw[0][0]
                    
                if state != 0:
                    choice = None
                    outcomes = []
                    
                    for item in range(len(raw[story][state])):
                        if token.match(raw[story][state][item]):
                            raw[story][state][item] = token.match(raw[story][state][item]).group()
                        if raw[story][state][item][0] == 'd':
                            if choice != None:
                                print('Error! More than one decision in a path state!')
                            choice = raw[story][state][item]
                        elif token.match(raw[story][state][item]):
                            outcomes.append(raw[story][state][item])
                            
                    raw[story][state] = (choice, outcomes)
                    
            del raw[story][0]
            
        return raw, initial
        
    def nat_place(self, place, loc = True):
        if place != 'home' and place != 'work':
            place = 'the ' + place
            if not loc:
                return place
            elif place != 'the city' and place != 'the parlor' and place != 'the hideout':
                place = 'at ' + place
            else:
                place = 'in ' + place
        else:
            if not loc:
                return place
            place = 'at ' + place
        return place
    
    def nat_char(self, character):
        if character == self.main:
            return 'you'
        if character in ['friend', 'crush', 'father', 'stepmother']:
            return 'your ' + character
        else:
            return 'the ' + character
    
    def nat_obj(self, obj):
        if obj in ['key', 'painting', 'body']:
            return 'a ' + obj
        elif obj in ['artifact']:
            return 'an ' + obj
        else:
            return obj
            
    def naturalize(self, typ, obj):
        if typ == 'place':
            return self.nat_place(obj, False)
        elif typ == 'character':
            return self.nat_char(obj)
        elif typ == 'object':
            return self.nat_obj(obj)
        
    def make_sentence(self, subj, verb, obj):
        if subj:
            sentence = self.nat_char(subj) + ' '
        else:
            sentence = ''
        
        if not subj:
            sentence += verb
        elif subj == self.main:
            sentence += verb
        else:
            if verb == 'study':
                sentence += 'studies'
            elif verb in ['go', 'search', 'kiss']:
                sentence += verb + 'es'
            else:
                sentence += verb + 's'
        
        if obj:
            sentence += ' '
            if 'ditrans(' in obj:
                direct, indir = obj[8:].split('),')
                dir_typ, dir_obj = direct.split('(')
                indir_typ, indir_obj = indir.split('(')
                dir_obj = self.naturalize(dir_typ, dir_obj)
                indir_obj = self.naturalize(indir_typ, indir_obj)
                sentence += dir_obj + ' '
                if verb in ['request', 'steal']:
                    sentence += 'from ' + indir_obj
                else:
                    sentence += 'to ' + indir_obj
            elif 'trans(' in obj:
                typ, obj = obj[6:].split('(')
                obj = self.naturalize(typ, obj)
                if verb in ['search']:
                    sentence += 'for ' + obj
                elif verb in ['lie', 'go', 'talk']:
                    if verb == 'go' and obj == 'home':
                        sentence += obj
                    else:
                        sentence += 'to ' + obj
                else:
                    sentence += obj
        
        if subj:
            sentence += '.'
        
        return sentence

    def clean_decision(self, text):
        text = text[14:-4]
        verb, obj = text.split(',', 1)
        if obj == 'no':
            obj = None
        return self.make_sentence(None, verb, obj)
        
    def clean_occurs(self, text):
        text = text.split('))),act(')[0][17:]
        subj, obj = text.split('),verb(')
        verb, obj = obj.split(',',1)
        if obj == 'no':
            obj = None
        return self.make_sentence(subj, verb, obj)

    def print_state(self):
        # takes list of outcomes

        new_items = []
        inventory = []
        followers = []

        for item in self.state:
            if item == 'story(rising)':
                print('act i\n')
            elif item == 'story(climax)':
                print('act ii\n')
            elif item == 'story(falling)':
                print('act iii\n')
            elif 'setting' in item:
                self.setting = item[8:-1]
                self.setting = self.nat_place(self.setting)
            elif 'is(' in item and 'adj(follower)' in item:
                followers.append(item[13:item.find('),adj(f')])
            elif self.main in item and 'has(' in item:
                inventory.append(item[item.find('object(')+7:-2])
            elif 'occurs' in item:
                new_items.append(item)
        
        if self.main[0] in ['a', 'e', 'i', 'o', 'u']:
            print('you are an ' + self.main + '.')
        else:
            print('you are a ' + self.main + '.')
        print('you are ' + self.setting + '.')
        
        if len(followers) > 0:
            follower_text = 'the '
            if len(followers) == 1:
                follower_text = 'the ' + followers[0]
            else:
                for idx in range(len(followers) - 1):
                    follower_text += followers[idx]
                    follower_text += ' and the '
                follower_text += followers[-1]
            print(follower_text + ' is by your side.')
                
        for idx in range(len(inventory)):
            inventory[idx] = self.nat_obj(inventory[idx])
                
        if len(inventory) > 0:
            inv_text = ''
            if len(inventory) == 1:
                inv_text = inventory[0]
            else:
                for idx in range(len(inventory) - 1):
                    inv_text += inventory[idx]
                    inv_text += ' and '
                inv_text += inventory[-1]
        else:
            inv_text = 'nothing'
        print('you have ' + inv_text + '.\n')
        
        if len(new_items) > 0:
            for item in new_items:
                print(self.clean_occurs(item))
            print()

    def play(self):
        print('start.\n')
        self.choose()
    
    def progress(self, decision = None):
       
        if 'story(end)' in self.stories[0][0][1]:
            print('the end!\n')
            return
        
        self.state = self.stories[0][0][1]
        
        # no decision means all paths have same next state (usually story change)
        if decision == None:
            self.print_state()
        else: # use decision to print choices
            new_stories = []
            for idx in range(len(self.stories)):
                if self.stories[idx][0][0] == decision:
                    new_stories.append(self.stories[idx])
            self.stories = new_stories
            self.state = self.stories[0][0][1]
            self.print_state()

        # remove first state for all, continue to choose
        for story in self.stories:
            del story[0]
        
        self.choose()
            
    def choose(self):
        # make next decision
        # gather choices
        list_choices = []
        for idx in range(len(self.stories)):
            list_choices.append(self.stories[idx][0][0])
        list_choices = list(set(list_choices))
        
        if list_choices == [None]:
            self.progress()
        else:
            choices = {}
            index = 1
            for item in list_choices:
                choices[index] = item
                index += 1
                
            for key in choices.keys():
                print(str(key) + ':\t' + self.clean_decision(choices[key]))
            print()
            
            while True:
                decision = input("make a decision (or 'q' to start over).\n")
                if decision == 'q':
                    print()
                    break
                try:
                    if int(decision) in choices.keys():
                        print()
                        self.progress(choices[int(decision)])
                        break
                    else:
                        print('invalid response.\n')
                except ValueError:
                    print('invalid response.\n')

stories = {1: ('heist','01-heist.txt'), 
           2: ('lost child','02-lost-child.txt'), 
           3: ('superhero','03-superhero.txt'), 
           4: ('ghost story','04-ghost-story.txt'), 
           5: ('murder mystery','05-murder-mystery.txt'), 
           6: ('high school prom','06-high-school-prom.txt'), 
           7: ('ancient city','07-ancient-city.txt')}

for key in stories.keys():
    print(str(key) + ':\t' + stories[key][0])
print()

while True:
    story_num = input("enter a story number to start, or 'q' to quit.\n")
    if story_num == 'q':
        print('bye!')
        break
    try:
        if int(story_num) in stories.keys():
            print('loading...\n')
            current = Story('results/' + stories[int(story_num)][1])
            current.play()
        else:
            print('invalid response.\n')
    except ValueError:
        print('invalid response.\n')
