package com.amarsoft.app.bizmethod;

import java.util.HashMap;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class SystemManage {
	private String paras;//参数串
	private String splitStr;//分隔符参数:默认值@@
	private String paraSplit;//参数与值的分隔：默认值@~
	public String getParaSplit() {
		return paraSplit;
	}
	public void setParaSplit(String paraSplit) {
		this.paraSplit = paraSplit;
	}
	public String getParas() {
		return paras;
	}
	public void setParas(String paras) {
		this.paras = paras;
	}
	public String getSplitStr() {
		return splitStr;
	}
	public void setSplitStr(String splitStr) {
		this.splitStr = splitStr;
	}
	
	public String selectOrgLevel(JBOTransaction tx) throws JBOException{
		HashMap<String, String> as = ParseAttirbutesTool.parseParas(paras);
		BizObjectQuery query = JBOFactory.getBizObjectManager("jbo.sys.ORG_INFO",tx)
		.createQuery("select OrgLevel from O where orgid=:OrgID")
		.setParameter("OrgID", as.get("orgID"))
 		;
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
		if(bos!=null && bos.size()>0){
			return bos.get(0).getAttribute("OrgLevel").toString();
		}else{
			return "";
		}
	}
}
