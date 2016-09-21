package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.app.als.guaranty.model.GuarantyConst;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.manage.NameManager;

public class CR_080 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

    private DocExtClass[] extobj1;

	public CR_080() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_080.initObject()");
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String customerID = "";
		List<DocExtClass> results = new ArrayList<DocExtClass>();
		DocExtClass resu = null;
		
		try {
			//首先查询出对应的contract编号
			//首先查询出对应的contract编号
			m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_CONTRACT);
			q = m.createQuery("o.GuarantyType='010010' and o.SerialNo in (select  AR.ObjectNo  from jbo.app.APPLY_RELATIVE AR where AR.SerialNo =:serialNo)").setParameter("serialNo",sObjectNo);
			List<BizObject> contracts = q.getResultList();
			if(contracts.size() > 0){
				for(int i=0;i<contracts.size();i++){
					BizObject contract = contracts.get(i);
					String sContractNo = contract.getAttribute("SerialNo").getString();
					String currencyNo = contract.getAttribute("GUARANTYCURRENCY").getString();
					String currency = CodeManager.getItemName("Currency", currencyNo);//担保币种
					String guarantyForm = contract.getAttribute("GUARANTEEFORM").getString();
					String guarantorName=contract.getAttribute("GuarantorName").getString();
					String guarantyType = CodeManager.getItemName("AssureStyle", guarantyForm);//保证担保形式
					double dGuarantyValue=contract.getAttribute("GuarantyValue").getDouble();
					resu=new DocExtClass();
					resu.setAttr1(guarantorName);
					resu.setAttr2(currency);
					resu.setAttr3(guarantyType);
					resu.setAttr4(DataConvert.toMoney(dGuarantyValue));
					//将查询结果放入List中
					results.add(resu);
				}
			}
			extobj1 = new DocExtClass[results.size()];
			if(results.size()>0){//将查询出的List转化成数组
				for(int i=0;i<extobj1.length;i++){
					extobj1[i] = results.get(i);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
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

