
var main = (function(parent, global) {
    function init() {
        var mimeType = decodeURIComponent(util.getMimeType());
        var uri = decodeURIComponent(util.getResourceUri());
        if (mimeType.indexOf('image') != -1 && uri.indexOf('mp4') == -1) {
            var elem = document.getElementById('image');
            elem.src = util.getResourceUri();
            elem.crossorigin = "anonymous";
            elem.onload = function() {
                console.log("onload: " + decodeURIComponent(util.getResourceUri()));
            }
        } else  if (mimeType.indexOf('image') != -1 && uri.indexOf('mp4') != -1) {
           var mediaId = uri.replace("http://localhost:4035/gotapi/files?uri=", "");
           util.doMediaPlayerMediaPut(util.getServiceId(), util.getAccessTokenQuery(), mediaId,null);
        } else {
            sendRequest('GET', uri, null, function(status, responseText) {
                var elem = document.getElementById('text');
                if (status == 200) {
                    elem.innerHTML = util.escapeText(responseText);
                } else {
                    elem.innerHTML = "通信に失敗しました。";
                }
            });
        }
    }
    parent.init = init;

    function back() {
        location.href = "./checker.html?serviceId=" + util.getServiceId() + '&profile=' + util.getProfileQuery();
    }
    parent.back = back;
    function createXMLHttpRequest() {
        try {
            return new XMLHttpRequest();
        } catch(e) {}
        try {
            return new ActiveXObject('MSXML2.XMLHTTP.6.0');
        } catch(e) {}
        try {
            return new ActiveXObject('MSXML2.XMLHTTP.3.0');
        } catch(e) {}
        try {
            return new ActiveXObject('MSXML2.XMLHTTP');
        } catch(e) {}
        return null;
    }

    function sendRequest(method, uri, body, callback) {
         var xhr = createXMLHttpRequest();
         xhr.onreadystatechange = function() {
             switch (xhr.readyState) {
             case 1:
                 try {
                     xhr.setRequestHeader("X-GotAPI-Origin".toLowerCase(), "http://ios_assets");
                 } catch (e) {
                     return;
                 }
                 xhr.send(body);
                 break;
             case 2:
             case 3:
                break;
             case 4:
                 callback(xhr.status, xhr.responseText);
                 break;
             default:
                 break;
             }
        };
        xhr.open(method, uri);
    }

    return parent;
})(main || {}, this.self || global);
