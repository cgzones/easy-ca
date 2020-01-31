<html>
    <head>
        <title>Certificate Authority Overview</title>
    </head>

    <body>
        <h1>Certificates</h1>

        <h2>{{CA_HTML_ROOT_TITLE}}</h2>

        <p>
            Name   : {{CA_NAME}}   <br/>
            Domain : {{CA_DOMAIN}} <br/>
        </p>

        <p>
            Root CA: <a href="{{CA_HTML_ROOT_NAME}}.crt">Show</a> (<a href="{{CA_HTML_ROOT_NAME}}.crt" download>Download</a>)<br>
            SHA1 fingerprint: {{CA_HTML_ROOT_HASH}}<br>
            Valid until: {{CA_HTML_ROOT_VALID_UNTIL}}
        </p>

        <p>
            Revocation list: <a href="{{CA_HTML_ROOT_NAME}}.crl">Show</a> (<a href="{{CA_HTML_ROOT_NAME}}.crl" download>Download</a>)<br>
            Revoked certificates: {{CA_HTML_ROOT_REVOKED}}
        </p>

        <hr>

        <p>Updated on {{CA_HTML_UPDATED}}</p>
    </body>
</html>
