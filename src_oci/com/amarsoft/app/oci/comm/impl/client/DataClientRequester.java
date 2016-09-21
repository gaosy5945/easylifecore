package com.amarsoft.app.oci.comm.impl.client;

import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPMessage;

import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
/**
 * @author ckxu
 * @throws OCIException
 * @description 这里我修改了原来的apache的SOAP封装方式,使用 javax.xml.soap.SOAPMessage的发送连接方式获取数据
 * */
public class DataClientRequester implements IRequester{

	@Override
	public Object execute(OCITransaction transaction) throws OCIException {
		Object requestData = transaction.getRequestData();
		if(!(requestData instanceof SOAPMessage)) 
			throw new OCIException("Request Data Type Error.");
		try{
			SOAPMessage reqSoap  = (SOAPMessage)requestData;
			//创建连接并发送请求
			SOAPConnection connection = SOAPConnectionFactory.newInstance().createConnection();
			//调用请求并获取数据,将所有的数据传输到交易里面去 
			SOAPMessage responseData = connection.call(reqSoap, transaction.getProperty("EndPoint"));
			transaction.setResponseData(responseData);
		}catch(Exception e){
			e.printStackTrace();
			throw new OCIException("WebService Send Message (endPoint=" + transaction.getProperty("EndPoint") + "  operation="+ transaction.getProperty("Operation") +")", e);
		}
		return null; 
	}
}
