getTitle();
// loadwithCache()
window.addEventListener("load", function() {
    document.getElementsByTagName("link")[0].import.replaceChild(extern.getElementsByTagName("body")[0], document.getElementsByTagName("body")[0]);
}, false);

function getTitle() {
    // alert("titel loaded" + window.location.hostname);
    document.title = window.location.hostname;
}

function loadwithCache(name, url) {
    requireScript(name, '0.0.5', url);
    // requireScript('jquery', '1.11.5', 'http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js', function() {

    // });
}
// cach data
function _cacheScript(c, d, e) {
    var a = new XMLHttpRequest;
    a.onreadystatechange = function() { 4 == a.readyState && (200 == a.status ? localStorage.setItem(c, JSON.stringify({ content: a.responseText, version: d })) : console.warn("error loading " + e)) };
    a.open("GET", e, !0);
    a.send()
}

function _loadScript(c, d, e, a) {
    var b = document.createElement("script");
    b.readyState ? b.onreadystatechange = function() { if ("loaded" == b.readyState || "complete" == b.readyState) b.onreadystatechange = null, _cacheScript(d, e, c), a && a() } : b.onload = function() {
        _cacheScript(d, e, c);
        a && a()
    };
    b.setAttribute("src", c);
    document.getElementsByTagName("head")[0].appendChild(b)
}

function _injectScript(c, d, e, a) {
    var b = document.createElement("script");
    b.type = "text/javascript";
    c = JSON.parse(c);
    var f = document.createTextNode(c.content);
    b.appendChild(f);
    document.getElementsByTagName("head")[0].appendChild(b);
    c.version != e && localStorage.removeItem(d);
    a && a()
}
//name,version,url,callback
function requireScript(c, d, e, a) {
    var b = localStorage.getItem(c);
    null == b ? _loadScript(e, c, d, a) : _injectScript(b, c, d, a)
};