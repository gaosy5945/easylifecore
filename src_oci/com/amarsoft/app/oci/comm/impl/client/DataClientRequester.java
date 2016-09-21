package com.amarsoft.app.oci.comm.impl.client;

import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPMessage;

import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.OCIException;
/**
 * @author ckxu
 * @throws OCIException
 * @description �������޸���ԭ����apache��SOAP��װ��ʽ,ʹ�� javax.xml.soap.SOAPMessage�ķ������ӷ�ʽ��ȡ����
 * */
public class DataClientRequester implements IRequester{

	@Override
	public Object execute(OCITransaction transaction) throws OCIException {
		Object requestData = transaction.getRequestData();
		if(!(requestData instanceof SOAPMessage)) 
			throw new OCIException("Request Data Type Error.");
		try{
			SOAPMessage reqSoap  = (SOAPMessage)requestData;
			//�������Ӳ���������
			SOAPConnection connection = SOAPConnectionFactory.newInstance().createConnection();
			//�������󲢻�ȡ����,�����е����ݴ��䵽��������ȥ 
			SOAPMessage responseData = connection.call(reqSoap, transaction.getProperty("EndPoint"));
			transaction.setResponseData(responseData);
		}catch(Exception e){
			e.printStackTrace();
			throw new OCIException("WebService Send Message (endPoint=" + transaction.getProperty("EndPoint") + "  operation="+ transaction.getProperty("Operation") +")", e);
		}
		return null; 
	}
}
