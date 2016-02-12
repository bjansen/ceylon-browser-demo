import ceylon.net.http.server.endpoints {
    RepositoryEndpoint,
    serveStaticFile
}
import ceylon.net.http.server {
    newServer,
    startsWith,
    AsynchronousEndpoint,
    Request
}
import java.util {
    Collections
}
import ceylon.interop.java {
    javaString
}
import com.redhat.ceylon.cmr.ceylon {
    CeylonUtils
}
import ceylon.net.http {
    get
}

"Run the module `com.acme.server`."
shared void run() {
    value outputDir = (process.propertyValue("user.dir") else "")
            + "/modules";
    
    value repoManager = CeylonUtils
            .repoManager()
            .extraUserRepos(Collections.singletonList(javaString(outputDir)))
            .buildManager();

    value modulesEp = RepositoryEndpoint("/modules", repoManager);

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