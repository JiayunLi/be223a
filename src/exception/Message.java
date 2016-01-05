package exception;

/**
 * Created by jiayunli on 15/11/22.
 */
public class Message {
    private String threadId;
    private String total;

    public void setThreadId(String threadId) {
        this.threadId = threadId;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public String getThreadId() {
        return threadId;
    }

    public String getTotal() {
        return total;
    }
}
