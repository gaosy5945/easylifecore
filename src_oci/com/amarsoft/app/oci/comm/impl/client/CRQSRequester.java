package com.amarsoft.app.oci.comm.impl.client;


import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.app.oci.ws.crqs.CRQSHelper;
import com.amarsoft.are.ARE;

public class CRQSRequester implements IRequester{

	@Override
	public Object execute(OCITransaction transaction) throws OCIException {
		Object requestData = transaction.getRequestData();
		StringBuilder sb = new StringBuilder("");
		String version = transaction.getProperty("XMLVERSION");
		if(version == null || "".equals(version)) version = "1.0";
		String encoding = transaction.getProperty("XMLENOCDING");
		if(version == null || "".equals(version)) version = ARE.getProperty("CharSet","GBK");
		String endPoint = transaction.getProperty("EndPoint");
		sb.append("<?xml version=\"" + version + "\" encoding=\"" + encoding + "\"?>");
		sb.append(requestData.toString());
		transaction.setRequestData(sb.toString());
		try {
			String result = CRQSHelper.executeQuery(endPoint , sb.toString());
			transaction.setResponseData(result);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			throw new OCIException(e.getMessage());
		}
		
		return requestData;
	}

}
