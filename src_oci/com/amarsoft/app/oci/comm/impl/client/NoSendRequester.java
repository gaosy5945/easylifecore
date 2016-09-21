package com.amarsoft.app.oci.comm.impl.client;


import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.are.ARE;

/**
 * webservice 方式连接
 * @author xjzhao
 *
 */
public class NoSendRequester implements IRequester {
	public Object execute(OCITransaction transaction) throws OCIException {
		Object requestData = transaction.getRequestData();
		StringBuilder sb = new StringBuilder("");
		String version = transaction.getProperty("XMLVERSION");
		if(version == null || "".equals(version)) version = "1.0";
		String encoding = transaction.getProperty("XMLENOCDING");
		if(version == null || "".equals(version)) version = ARE.getProperty("CharSet","GBK");
		sb.append("<?xml version=\"" + version + "\" encoding=\"" + encoding + "\"?>");
		sb.append(requestData.toString());
		transaction.setRequestData(sb.toString());
		transaction.setResponseData(sb.toString());
		return requestData;
	}
}
