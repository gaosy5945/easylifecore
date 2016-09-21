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
 * 征信信息初始化
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
		CRQSResult result = CRQSManger.singleQuery(paraHashMap,"CRQS_QUERY");  //调用征信平台接口下载征信报告至本地
		
		if (result.getResult()) 
			 return getMessageObject(result.getMessage());
		else {
			if (Classification.QUERY_RESPONSE_NOTEXSISTS.equals(result.getMessage())) 
				return null;	
			else 
				throw new CmdException("客户："+name+"，证件号："+certNo+"，不存在本地征信报告");
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
		//将征信xml文件封装成 征信对象。
		//IReportMessage message = new IParseReportMessage().createObjectFromXML(new File(filePath), "single");  //生成征信报告对象
		IReportMessage message = new IParseReportMessage().createObjectFromXML(new File(filePath),"single");
		//IReportMessage message = new IParseReportMessage().createObjectFromXML(new File("D:/crq/2012073000001093893730.xml"), "single");  //生成征信报告对象
		return message;
	}
}
