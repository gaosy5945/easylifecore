package com.amarsoft.app.oci.ws.crqs;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMXMLBuilderFactory;
import org.apache.axiom.om.OMXMLParserWrapper;

import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.OMGenerator;
import com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReport;
import com.amarsoft.app.oci.ws.crqs.service.webservice.QueryINewCreditReportResponse;
import com.amarsoft.app.oci.ws.crqs.service.webservice.WebServiceStub;

public class CRQSHelper {
	/**
	 * ���ͱ��� ִ�е��ʲ�ѯ
	 * @param xml
	 * @return
	 * @throws Exception
	 */
	public static String executeQuery(String endPoint , String xml) throws Exception{
		if(xml == null ) xml = "";
		WebServiceStub stub = null;
		try
		{
			stub = new WebServiceStub(endPoint);
			//QueryICreditReport request = new QueryICreditReport();
			QueryINewCreditReport newRequest = new QueryINewCreditReport(); 
			newRequest.setArgs0(xml);
			//request.setArgs0(xml);
			QueryINewCreditReportResponse result = stub.queryINewCreditReport(newRequest);	
			return result.get_return();
		}catch(Exception ex)
		{
			throw ex;
		}finally{
			if(stub != null) stub.cleanup();
		}
	}
	
	//��ȡ���ŷ��ص�״̬��  ����
	public static String getResultCode(OMElement element) throws UnsupportedEncodingException{
		element = getTargetOMElement(element, "MSG" , "SingleQueryResultMessage0009"  );
		if(element == null) return "";
		element = getTargetOMElement(element, "ResultCode");
		return element.getText();
	}
	//��ȡ
	public static String geResultInfo(OMElement element) throws UnsupportedEncodingException{
		element = getTargetOMElement(element, "MSG" , "MsgReturn9005" , "Information" );
		return element.getText();
	}
	
	/**
	 * ��ȡ�������ű��ĵı��
	 * @param xml
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static String getReportSN(OMElement element , String charCode) throws UnsupportedEncodingException{
		element = getTargetOMElement(element, "MSG" , "SingleQueryResultMessage0009" , "ReportMessage" );
		element = OMGenerator.parseStringtoOM(element.getText() , charCode);
		element = getTargetOMElement(element, "Header" , "MessageHeader" , "ReportSN");
		return element.getText();
	}
	
	/**
	 * ����Ƿ� ���� �������ż�¼ �����е�һ�β�ѯ�� ���صĽṹ����reportSN��
	 * @param element
	 * @param charCode
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static boolean isReprotSNExsists(OMElement element , String charCode) throws UnsupportedEncodingException{
		element = getTargetOMElement(element, "MSG" , "SingleQueryResultMessage0009" , "ReportMessage" );
		element = OMGenerator.parseStringtoOM(element.getText() , charCode);
		element = getTargetOMElement(element, "Header" , "MessageHeader");
		if (element == null) return false;
		return true;
	}
	
	/**
	 * �����ر�������xml�ļ�
	 * @param xml
	 * @param name
	 * @return
	 * @throws Exception
	 */
	public static String saveXML(String xml , String name) throws Exception{
		FileOutputStream fs = null;
		BufferedOutputStream bs = null;
		try{
			fs = new FileOutputStream(new File(getXMLLocation()  + name + ".xml" ) , false);
			bs = new BufferedOutputStream(fs);
			bs.write(xml.getBytes());
			bs.flush();
		}finally{
			if(bs != null) bs.close();
			if(fs != null) fs.close();
		}
		return getXMLLocation()  + name + ".xml" ;
	}
	
	/**
	 * ����ָ���ڵ�
	 * @param element
	 * @param args
	 * @return
	 */
	private static OMElement getTargetOMElement(OMElement element , String... args ){
		for(String s : args)
			element = element.getFirstChildWithName(new QName(s));
		return element;
	}
	
	private static String getXMLLocation() throws Exception{
		return OCIConfig.getProperty("CrqsSinPath", "");
	}
}
