package com.amarsoft.app.oci.ws.decision.prepare;

import java.io.File;
import java.util.LinkedHashMap;
import java.util.Map;

import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.app.crqs2.i.parse.from.IParseReportMessage;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.ws.crqs.CRQSManger;
import com.amarsoft.app.oci.ws.crqs.CRQSResult;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * ������Ϣ��ʼ��
 * 
 * @author t-liuyc
 * 
 */
public class CmdInit implements CommandInit {

	@Override
	public IReportMessage init(String certNo, String certType, String name,String userId)
			throws Exception {
		Map paraHashMap = new LinkedHashMap();
		String QuerOrgcode = OCIConfig.getProperty("CrqsQuerOrgcode","");
		paraHashMap.put("QuerOrgcode",QuerOrgcode);
		paraHashMap.put("UserCode",userId);
		paraHashMap.put("Name", name);
		paraHashMap.put("Certtype", certType);
		paraHashMap.put("Certno", certNo);
		paraHashMap.put("Queryreason", "02");
		CRQSResult result = CRQSManger.singleQuery(paraHashMap,"CRQS_QUERY");  //��������ƽ̨�ӿ��������ű���������
		
		if (result.getResult()) 
			 return getMessageObject(result.getMessage());
		else {
			if (Classification.QUERY_RESPONSE_NOTEXSISTS.equals(result.getMessage())) 
				return null;	
			else 
				throw new CmdException("�ͻ���"+name+"��֤���ţ�"+certNo+"�������ڱ������ű���");
		}
		//return getMessageObject(result.getMessage());
//		if (result.getResult()) return getMessageObject(result.getMessage());
//		return null;
	}

	public IReportMessage getMessageObject(String reportSN)
			throws JBOException {
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.icrp.ICRP_REPORTMAININFO");
		BizObject bo = bm.createQuery("o.REPORTSN = :REPORTSN").setParameter("REPORTSN", reportSN).getSingleResult(false);
		String filePath = bo.getAttribute("FILEPATH") + "\\" + bo.getAttribute("FILENAME");
		filePath = filePath.replaceAll("\\\\", "/");
		//������xml�ļ���װ�� ���Ŷ���
		//IReportMessage message = new IParseReportMessage().createObjectFromXML(new File(filePath), "single");  //�������ű������
		IReportMessage message = new IParseReportMessage().createObjectFromXML(new File(filePath),"single");
		//IReportMessage message = new IParseReportMessage().createObjectFromXML(new File("D:/crq/2012073000001093893730.xml"), "single");  //�������ű������
		return message;
	}
}
