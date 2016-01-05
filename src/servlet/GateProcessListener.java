package servlet;


import org.apache.commons.fileupload.ProgressListener;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by jiayunli on 15/11/14.
 */

public class GateProcessListener extends HttpServlet {
    public GateProcessListener() throws IOException {
    }
    //static int i;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doPost(request,response);
        // response.sendRedirect("");
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException{
        String current = null;
        int threadId = Integer.parseInt(request.getParameter("threadId"));
       // int totalNum = Integer.parseInt(request.getParameter("totalNum"));
        try {
            //current = gatethread.call();
            current = GateServlet.gatethreads.get(threadId).call();
        } catch (Exception e) {
            e.printStackTrace();
        }
        // request.setAttribute("thread",thread);
       // i++;
        int currentID = Integer.parseInt(current);
        //int percentage = (currentID/totalNum)*100;
     //   String progress = percentage + "%";
        response.getWriter().write(String.valueOf(currentID));
      //  response.getWriter().write(current);

    }
}
