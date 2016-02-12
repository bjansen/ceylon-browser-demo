import ceylon.net.http {
    get
}
import ceylon.net.http.server {
    newServer,
    startsWith,
    AsynchronousEndpoint,
    Request
}
import ceylon.net.http.server.endpoints {
    RepositoryEndpoint,
    serveStaticFile
}

"Run the module `com.acme.server`."
shared void run() {
    value modulesEp = RepositoryEndpoint("/modules");

    function mapper(Request req) 
            => req.path == "/" then "/index.html" else req.path;
    
    value staticEp = AsynchronousEndpoint(
        startsWith("/"), 
        serveStaticFile("www", mapper),
        {get}
    );

    value server = newServer { modulesEp, staticEp };
    
    server.start();
}