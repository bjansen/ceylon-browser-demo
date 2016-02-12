import ceylon.interop.browser.dom {
    document,
    Event
}
import ceylon.interop.browser {
    newXMLHttpRequest
}

"Run the module `com.acme.client`."
shared void run() {
    value req = newXMLHttpRequest();

    req.onload = void (Event evt) {
        if (exists container = document.getElementById("container")) {
            value title = document.createElement("h1");
            title.textContent = "Hello from Ceylon";
            container.appendChild(title);
            
            value content = document.createElement("p");
            content.innerHTML = req.responseText;
            container.appendChild(content);
        }
    };
    
    req.open("GET", "/msg.txt");
    req.send();
}