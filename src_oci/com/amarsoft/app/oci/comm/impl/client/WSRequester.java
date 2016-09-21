package com.amarsoft.app.oci.comm.impl.client;

import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.OperationClient;
import org.apache.axis2.client.Options;
import org.apache.axis2.client.ServiceClient;
import org.apache.axis2.context.MessageContext;
import org.apache.axiom.soap.SOAPEnvelope;

import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;

/**
 * webservice 方式连接
 * @author xjzhao
 *
 */
public class WSRequester implements IRequester {

	public Object execute(OCITransaction transaction) throws OCIException {
		Object responseData = null;
		Object requestData = transaction.getRequestData();
		if(!(requestData instanceof SOAPEnvelope)) throw new OCIException("Request Data Type Error.");
		
		ServiceClient sc = null;
		try{
			EndpointReference targetEPR =  new EndpointReference(transaction.getProperty("EndPoint"));//调用地址
			
			sc = new ServiceClient();
			OperationClient opClient = sc.createClient(ServiceClient.ANON_OUT_IN_OP);
			
			MessageContext message = new MessageContext();
			Options opts = message.getOptions();
			
			opts.setTo(targetEPR);
			opts.setAction(transaction.getProperty("Operation"));
			message.setEnvelope((SOAPEnvelope)requestData);
			opClient.addMessageContext(message);
			opClient.execute(true);
			MessageContext result = opClient.getMessageContext("In");
			
			responseData = result.getEnvelope();
			transaction.setResponseData(responseData);
		}catch(Exception e){
			try{
				if(sc != null)
				{
					sc.cleanupTransport();
					sc.cleanup();
				}
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			e.printStackTrace();
			throw new OCIException("WebService Send Message (endPoint=" + transaction.getProperty("EndPoint") + "  operation="+ transaction.getProperty("Operation") +")", e);
		}
		return sc;
	}

}
