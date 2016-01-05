package exception;

import java.util.HashMap;

/**
 * Created by jiayunli on 15/11/22.
 */
public class GateException extends Exception {
    private String msg;
    public GateException(String msg){
        this.msg = msg;
    }
    public String toString(){

        return msg;
    }
}
