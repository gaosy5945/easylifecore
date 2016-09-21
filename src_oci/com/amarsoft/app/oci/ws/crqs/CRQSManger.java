package com.amarsoft.app.oci.ws.crqs;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.axiom.om.OMElement;

import com.amarsoft.app.crqs2.AmarIParseManager;
import com.amarsoft.app.crqs2.i.sql.build.IBuildSQLSave;
import com.amarsoft.app.crqs2.tool.FileProcessHandler;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.OMGenerator;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.ws.decision.prepare.Classification;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

public class CRQSManger {
	public static CRQSResult singleQuery(Map map,String clientId) throws Exception{
		OCITransaction transactionReq = OCIConfig.getTransactionByClientID(clientId,null);
		map.put("Queryformat" , transactionReq.getProperty("Queryformat"));
		map.put("QueryExtend1" , transactionReq.getProperty("QueryExtend1"));
		map.put("QueryExtend2" , transactionReq.getProperty("QueryExtend2"));
		map.put("OrgCode" , transactionReq.getProperty("OrgCode"));
		map.put("QuerySystem" , transactionReq.getProperty("QuerySystem")); 
		map.put("QueryForce" , transactionReq.getProperty("QueryForce"));
		map.put("QueryStyle" , transactionReq.getProperty("QueryStyle"));
		map.put("ReqStyle" , transactionReq.getProperty("ReqStyle"));
		map.put("Certtype", changeCertType(map.get("Certtype").toString()));
		transactionReq.fillMessage(map, null, null);
		transactionReq.getCommunicator().execute();
		

		CRQSResult cResult = new CRQSResult();
		String message = "";
		String result =  transactionReq.getResponseData().toString();
		OMElement element = OMGenerator.parseStringtoOM(result, transactionReq.getProperty("XMLENOCDING"));
		String status = CRQSHelper.getResultCode(element);  //��ȡ���ر���״̬��
		if(status.equals("90000")){ //�ж��Ƿ�ɹ�����			
			if (!isPBExsists(element ,transactionReq.getProperty("REPORTCODE"))) { //���в��������ż�¼ 
				message = Classification.QUERY_RESPONSE_NOTEXSISTS;
				cResult.setResult(false);
			} else {  //���д��ڼ�¼ ��ѯ�ɹ�
				message = storage(result , element ,transactionReq.getProperty("REPORTCODE")); //���������ɳ�html,�����
				cResult.setResult(true);
			}
		}else{
			message = CRQSHelper.geResultInfo(element); //��ѯʧ�ܷ��ش���ԭ��
			cResult.setResult(false);
		}
		cResult.setMessage(message);
		return cResult;
	}	
	

	
	
	public static void batchQueryRequest(String fileName) throws Exception{
		//CRQSFtpTool.uploadFile(fileName);
	}
	
	public static void batchQueryResponse(String fileName) throws IOException{
		List<File> list = new ArrayList<File>();
		list.add(new File(fileName));
		//new AmarIReportManager().saveXMLByList(list, "batch");
		new AmarIParseManager().saveXMLByList(list, "batch");
	}
	
	private static String changeCertType(String certType) throws Exception{
		Item item = CodeCache.getItem("CustomerCertType", certType);
		if(item == null) return "";
		return item.getBankNo();
	}
	
	private static synchronized String storage(String result , OMElement element , String reportCode) throws Exception{
		//���汨���ļ�
		String reportSN = CRQSHelper.getReportSN(element ,reportCode); //��ȡ���ű��ı��
		String location = CRQSHelper.saveXML(result, reportSN);  //���ر�������xml�ļ�
		File temp = new File(location.replace(".xml", ".html"));  
		if(temp.exists()) temp.delete();
		//��xml�ļ�����Ϊhtml�ļ� ------�ѸĶ�-------
		new AmarIParseManager().parseHTMLFileByFile_spd(location, location.replace(".xml", ".html"));
		if(checkExist(reportSN)) return reportSN;
		//�������  -----�ѸĶ� ----
		String msg = new FileProcessHandler().fileToString(location);
		String queryType = "single";
		IBuildSQLSave ibs = new IBuildSQLSave();
		ibs.setFile(new File(location));
		ibs.save(msg, queryType);	
//		List<File> list = new ArrayList<File>();
//		list.add(new File(location));	
//		new AmarIParseManager().saveXMLByList(list, "single");
		return reportSN;
	}
	
	//ͨ���Ƿ񷵻ر����ţ���������Ƿ���ڴ������ű��� 
	private static boolean isPBExsists(OMElement element , String reportCode) throws UnsupportedEncodingException {
		return CRQSHelper.isReprotSNExsists(element, reportCode);
	}
	
	//��鱾�����ݿ����Ƿ�������ţ������Ƿ�������ѯ��������Ϣ��
	private static boolean checkExist( String reportSN) throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.icrp.ICRP_REPORTMAININFO");
		BizObject bo = bm.createQuery("REPORTSN =:REPORTSN").setParameter("REPORTSN" , reportSN).getSingleResult(false);
		if(bo == null) return false;
		return true;
	}
}
