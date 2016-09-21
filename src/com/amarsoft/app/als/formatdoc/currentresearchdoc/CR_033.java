package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import java.util.List;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;

public class CR_033 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;

	public CR_033() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_033.initObject()");
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		
		String sCustomerID = "";
	
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			if(bo != null){
				sCustomerID=bo.getAttribute("CustomerID").getString();
			}
			
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
				q = m.createQuery("CustomerID =:CustomerID and RelationShip like '02%' and length(RelationShip)>2").setParameter("CUSTOMERID",sCustomerID);
				List<BizObject> relatives = q.getResultList();
				extobj1 = new DocExtClass[relatives.size()];
				if(relatives.size()>0){
					for(int i=0;i<relatives.size();i++){
						BizObject relative = relatives.get(i);
						extobj1[i] = new DocExtClass();
						extobj1[i].setAttr1(relative.getAttribute("CustomerName").getString());
						extobj1[i].setAttr2(DataConvert.toMoney(relative.getAttribute("INVESTMENTSUM").getDouble()/10000));
						extobj1[i].setAttr3(relative.getAttribute("INVESTMENTPROP").getString());
						extobj1[i].setAttr4(DataConvert.toMoney(relative.getAttribute("TOTALASSETS").getDouble()/10000));
						extobj1[i].setAttr5(DataConvert.toMoney(relative.getAttribute("NETASSETS").getDouble()/10000));
						extobj1[i].setAttr6(DataConvert.toMoney(relative.getAttribute("ANNUALINCOME").getDouble()/10000));
						extobj1[i].setAttr7(DataConvert.toMoney(relative.getAttribute("PUREINCOME").getDouble()/10000));

					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public boolean initObjectForEdit() {
		// do nothing
		return true;
	}

	public DocExtClass[] getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass[] extobj1) {
		this.extobj1 = extobj1;
	}
	
}
