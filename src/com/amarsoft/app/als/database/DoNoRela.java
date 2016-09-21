package com.amarsoft.app.als.database;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import java.util.List;

public class DoNoRela {

	/**
	 * @dlsong
	 * 根据数据表名找出其对应的显示模板名称
	 */
	public String tbNo="";
	public String JBOClass="";
	
	public String getJBOClass() {
		return JBOClass;
	}

	public void setJBOClass(String jBOClass) {
		JBOClass = jBOClass;
	}

	public String getTbNo() {
		return tbNo;
	}

	public void setTbNo(String tbNo) {
		this.tbNo = tbNo;
	}

	public String getRelaDono() throws JBOException{
		String sResult1="";	
			BizObjectManager m1 = JBOFactory.getBizObjectManager("jbo.sys.DATAOBJECT_CATALOG");
			List bo2=m1.createQuery("DOUPDATETABLE =:UpdateTable").setParameter("UpdateTable", tbNo).getResultList();
			BizObject bo = null;
			for(int i=0;i<bo2.size();i++){
				bo=(BizObject)bo2.get(i);
				sResult1+="@"+bo.getAttribute("DONO").getString();
			}
			if(sResult1.length()>0) return sResult1.substring(1);
			else return "";
		}


	public String getRelaOWNo() throws JBOException{
		String sResult1="";
			BizObjectManager m1 = JBOFactory.getBizObjectManager("jbo.ui.system.DATAOBJECT_CATALOG");
			List bo2=m1.createQuery("JBOCLASS =:JBOClass").setParameter("JBOClass", JBOClass).getResultList();
			BizObject bo = null;
			for(int i=0;i<bo2.size();i++){
				bo=(BizObject)bo2.get(i);
				sResult1+="@"+bo.getAttribute("DONO").getString();
			}
			if(sResult1.length()>0) return sResult1.substring(1);
			else return "";
		}
}