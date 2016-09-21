package com.amarsoft.app.oci.ws.decision.prepare;

import java.util.HashMap;
import java.util.List;
import java.util.Map;



import com.amarsoft.app.crqs2.i.bean.IReportMessage;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;

/**
 * 决策系统征信信息加工对象
 * 
 * @author t-liuyc
 * 
 */
public class DcIcrqExtractor {
	private Map<String, Object> source = new HashMap<String, Object>();
	public DcIcrqResult execute(String name, String certType, String certNo,String userId) throws Exception {
		source.put("name", name);
		source.put("certType", certType);
		source.put("certNo", certNo);
		source.put("userId",userId);
			
		if (name == null || certNo == null || certType == null)
			throw new CmdException(name+"不存在本地征信报告");
		getInitsInfo();
		DcIcrqResult dcIcrqResult = getValue();
		return dcIcrqResult;
	}

	// 获取申请人及申请人配偶信息
	private void getInitsInfo() throws Exception {
		List listInit = CmdXMLConfig.getListInit();
		for (int i = 0; i < listInit.size(); i++) {
			Map init = (Map) listInit.get(i);
			List inlist = (List) init.get("inMessage");
			String iname = " ";
			String icertType = " ";
			String icertNo = " ";
			for (int j = 0; j < inlist.size(); j++) {
				Map input = (Map) inlist.get(j);
				String order = input.get("paraorder").toString();
				if(order.equals("1")) iname = (String) input.get("paraname"); 
				else if(order.equals("2")) icertType = (String) input.get("paraname");
				else if(order.equals("3")) icertNo = (String) input.get("paraname");
				else continue;
			}
			String certNo = (String) source.get(icertNo);
			String name = (String) source.get(iname);
			String certType = (String) source.get(icertType);
			String userId = (String)source.get("userId");
			
			if (certNo == null || name == null || certType == null) {
				IReportMessage temp = null;
				List outlist = (List) init.get("outMessage");
				Map outInit = (Map) outlist.get(0);
				source.put(outInit.get("paraname").toString(), temp);
			} else {
				String className = (String) init.get("classname");
				CommandInit inti = (CommandInit) Class.forName(className).newInstance();// 征信执行单元初始化
				IReportMessage temp = inti.init(certNo, certType, name,userId);// 获取征信报告
				List outlist = (List) init.get("outMessage");
				Map outInit = (Map) outlist.get(0);
				source.put(outInit.get("paraname").toString(), temp);
				if (temp == null) continue;
				getPaterInfo(name,certType,certNo);
			}
		}
	}

	private void getPaterInfo(String name, String certType, String certNo) throws Exception {
		BizObjectManager bmci = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		BizObject boci = bmci.createQuery("select CUSTOMERID from O where CERTTYPE=:certtype and CERTID=:certid").setParameter("certtype", certType).setParameter("certid", certNo).getSingleResult(true);
		//BizObject boci = bmci.createQuery("select CUSTOMERID from O where CERTTYPE=:certtype and CERTID=:certid").setParameter("certtype", certType).setParameter("certid", certNo).getSingleResult(true);
		if(boci == null)
		{
			source.put("pname", null);
			source.put("pcertNo", null);
			source.put("pcertType", null);
			return;
		}
		String customerid = boci.getAttribute("CUSTOMERID").toString();
		BizObjectManager bmcr = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
		BizObject bocr = bmcr.createQuery("select RELATIVECUSTOMERID from O where CUSTOMERID=:customerid and RELATIONSHIP='2007'").setParameter("customerid", customerid).getSingleResult(true);
		if(bocr == null) {
			source.put("pname", null);
			source.put("pcertNo", null);
			source.put("pcertType", null);
		}else{
			String pCustomerid = bocr.getAttribute("RELATIVECUSTOMERID").toString();
			BizObject bocib = bmci.createQuery("select CUSTOMERNAME,CERTTYPE,CERTID from O where CUSTOMERID=:customerid").setParameter("customerid", pCustomerid).getSingleResult(true);
			String partnerName = bocib.getAttribute("CUSTOMERNAME").toString();
			String partnerType = bocib.getAttribute("CERTTYPE").toString();
			String partnerCertNo = bocib.getAttribute("CERTID").toString();
			source.put("pname", partnerName);
			source.put("pcertType", partnerType);
			source.put("pcertNo", partnerCertNo);
		}	
//		PersonalInfo personalInfo = temp.getPersonalInfo();
//		if (personalInfo == null) return;
//		Spouse spouse = personalInfo.getSpouse();
//		if (spouse == null) {
//			source.put("pname", null);
//			source.put("pcertNo", null);
//			source.put("pcertType", null);
//		} else {
//			String partnerName = spouse.getName();
//			source.put("pname", partnerName);
//			String partnerCertType = spouse.getCerttype();
//			Item[] items = CodeCache.getItems("CustomerCertType");
//			for (Item iTemp : items) {
//				if (iTemp.getBankNo() != null && partnerCertType.startsWith(iTemp.getBankNo())) {
//					partnerCertType = iTemp.getItemNo();
//					break;
//				}
//			}
//			source.put("pcertType", partnerCertType);
//			String partnerCertNo = spouse.getCertno();
//			source.put("pcertNo", partnerCertNo);
//		}
	}

	// 执行单元赋值
	private DcIcrqResult getValue() throws InstantiationException,IllegalAccessException, ClassNotFoundException, Exception {
		DcIcrqResult dcIcrqResult = new DcIcrqResult();
		List listUnit = CmdXMLConfig.getListUnit();
		for (int i = 0; i < listUnit.size(); i++) executeUnit(listUnit, i, dcIcrqResult);
		return dcIcrqResult;
	}

	// 运行执行单元
	private void executeUnit(List listUnit, int i, DcIcrqResult dcIcrqResult)
			throws InstantiationException, IllegalAccessException,ClassNotFoundException, Exception {
		Map unit = (Map) listUnit.get(i);
		String unitname = (String) unit.get("name");
		String defaultvalue = (String) unit.get("default");
		List inList = (List) unit.get("inMessage");
		Map inUnit = (Map) inList.get(0);
		String inparaname = (String) inUnit.get("paraname");
		String unitClassName = (String) unit.get("classname");
		IReportMessage temp = (IReportMessage) source.get(inparaname);
		if (temp == null) {
			dcIcrqResult.setAttribute(unitname, defaultvalue);
			return;
		}
		Command command = (Command) Class.forName(unitClassName).newInstance();
		Object value = command.execute((IReportMessage) source.get(inparaname));
		dcIcrqResult.setAttribute(unitname, value);
	}
}
