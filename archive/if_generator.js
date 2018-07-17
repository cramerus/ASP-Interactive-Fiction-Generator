function read(url) {
    var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
    var request = new XMLHttpRequest();
    request.open( "GET", url, false ); // false for synchronous request
    request.send( null );
    return xmlHttp.responseText;
}

function IF (path, current, future) {

    this._createTree = IFcreateTree;
    this._createBranch = IFcreateBranch;
    this._cleanPath = IFcleanPath;
    this._choose = IFchoose;
    this.play = IFplay;

    this.end = false;
    if (path != null) { // first time through:
        this.choice = null;
        this._createTree(path);
    } else { 
        return(this._createBranch(current, future));
        }
}

function IFcreateBranch(current, future) {
    return('hey');
}

function IFcreateTree (path) {
    return(2)
}

function IFcleanPath (path) {
    return(2)
}

function IFchoose (path) {
    return(2)
}

function IFplay (path) {
    return(2)
}


var http = require('http');

http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.end(read('http://www.rebekahjmc.com/files/theme/games/results.txt'));

}).listen(8000);

// this is a comment
