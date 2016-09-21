
/**
 * CRQSExceptionException.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:33:49 IST)
 */

package com.amarsoft.app.oci.ws.crqs.service.webservice;

public class CRQSExceptionException extends java.lang.Exception{

    private static final long serialVersionUID = 1413957384136L;
    
    private com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException faultMessage;

    
        public CRQSExceptionException() {
            super("CRQSExceptionException");
        }

        public CRQSExceptionException(java.lang.String s) {
           super(s);
        }

        public CRQSExceptionException(java.lang.String s, java.lang.Throwable ex) {
          super(s, ex);
        }

        public CRQSExceptionException(java.lang.Throwable cause) {
            super(cause);
        }
    

    public void setFaultMessage(com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException msg){
       faultMessage = msg;
    }
    
    public com.amarsoft.app.oci.ws.crqs.service.webservice.CRQSException getFaultMessage(){
       return faultMessage;
    }
}
    