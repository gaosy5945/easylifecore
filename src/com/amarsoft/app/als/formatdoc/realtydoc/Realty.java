package com.amarsoft.app.als.formatdoc.realtydoc;

import java.io.Serializable;

import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.CodeManager;

public class Realty extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
    private DocExtClass extobj1;
    private DocExtClass extobj2;
    private DocExtClass extobj3;
    private DocExtClass extobj4;
    private DocExtClass extobj5;
    private DocExtClass extobj6;
    private DocExtClass extobj7;
    private String opinion1 = "";
    private String opinion2 = "";

	public Realty() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("Realty.initObject()");
		String sObjectNo=this.getRecordObjectNo();
		String sObjectType=this.getRecordObjectType();
		if(sObjectNo==null)sObjectNo="";
		if(sObjectType==null)sObjectType="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
	
		String customerID = "";
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			if(bo != null){
				customerID = bo.getAttribute("CustomerID").getString();
			}
			extobj1 = new DocExtClass();
			extobj2 = new DocExtClass();
			extobj3 = new DocExtClass();
			extobj4 = new DocExtClass();
			extobj5 = new DocExtClass();
			extobj6 = new DocExtClass();
			extobj7 = new DocExtClass();
			if(customerID!=null&& !"".equals(customerID)){
				String projectNo = "";
				m = JBOFactory.getFactory().getManager("jbo.app.PROJECT_INFO");
				q = m.createQuery("select * from O where O.projectType='02' and O.projectno in (select pr.projectNo from jbo.app.PROJECT_RELATIVE pr where pr.objectType='Customer' and pr.ObjectNo=:CustomerID) order by O.projectno desc")
				     .setParameter("CustomerID",customerID);
				bo = q.getSingleResult();
				if(bo != null){
					projectNo = bo.getAttribute("ProjectNo").getString();
					extobj1.setAttr1(bo.getAttribute("ProjectName").getString());
					extobj1.setAttr2(bo.getAttribute("ProjectAdd").getString());
					extobj1.setAttr3(bo.getAttribute("DevelopmentName").getString());
					String contractorInfo = bo.getAttribute("ContractorInfo").getString();
					extobj1.setAttr4(CodeManager.getItemName("ContractorInfo", contractorInfo));
					extobj1.setAttr5(bo.getAttribute("BuildArea").getString());
					String projectLevel = bo.getAttribute("ProjectLevel").getString();
					extobj1.setAttr6(CodeManager.getItemName("ProjectType", projectLevel));
					extobj1.setAttr7(DataConvert.toMoney(bo.getAttribute("SUM2").getDouble()));
					extobj1.setAttr8(bo.getAttribute("HoldArea").getString());
					extobj1.setAttr9(bo.getAttribute("HoldType").getString());
					extobj1.setAttr0(bo.getAttribute("HouseArea").getString());
					extobj2.setAttr1(DataConvert.toMoney(bo.getAttribute("SUM1").getDouble()));
					extobj2.setAttr2(bo.getAttribute("EmporiumArea").getString());
					extobj2.setAttr3(DataConvert.toMoney(bo.getAttribute("SUM3").getString()));
					extobj2.setAttr4(bo.getAttribute("ScriptoriumArea").getString());
					extobj2.setAttr5(DataConvert.toMoney(bo.getAttribute("SUM4").getDouble()));
					extobj2.setAttr6(bo.getAttribute("CarportArea").getString());
					extobj2.setAttr7(DataConvert.toMoney(bo.getAttribute("SUM5").getDouble()));
					extobj2.setAttr8(bo.getAttribute("OtherArea").getString());
					extobj2.setAttr9(DataConvert.toMoney(bo.getAttribute("SUM6").getDouble()));
					extobj2.setAttr0(bo.getAttribute("RebuildArea").getString());
					extobj3.setAttr2(bo.getAttribute("UseInfo").getString());
					extobj3.setAttr3(bo.getAttribute("DimensionRadio").getString());
					extobj3.setAttr4(bo.getAttribute("VirescenceRadio").getString());
					extobj3.setAttr5(bo.getAttribute("COLONIZEPOWER").getString());
					extobj3.setAttr6(bo.getAttribute("Licence2").getString());
					extobj3.setAttr7(bo.getAttribute("Licence4").getString());
					extobj3.setAttr8(bo.getAttribute("Licence1").getString());
					extobj3.setAttr9(bo.getAttribute("Licence3").getString());
					extobj3.setAttr0(bo.getAttribute("Licence5").getString());
					extobj4.setAttr1(bo.getAttribute("OtherExamineInfo").getString());
					extobj4.setAttr2(DataConvert.toMoney(bo.getAttribute("PlanTotalCast").getDouble()/10000));
					extobj4.setAttr3(bo.getAttribute("ConstructTimes").getString());
					extobj4.setAttr4(DataConvert.toMoney(bo.getAttribute("ProjectCapital").getDouble()/10000));
					extobj4.setAttr5(bo.getAttribute("CapitalScale").getString());
					extobj4.setAttr7(bo.getAttribute("BEGINBUILDDATE").getString());
					extobj4.setAttr8(bo.getAttribute("EXPECTCOMPLETEDATE").getString());
				}
				
				m = JBOFactory.getFactory().getManager("jbo.app.PROJECT_BUDGET");
				q = m.createQuery("ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					double dSum = bo.getAttribute("EXESSUM15").getDouble(); 
					extobj5.setAttr1(DataConvert.toMoney(dSum));
					double d1 = bo.getAttribute("EXESSUM1").getDouble()/10000;
					extobj5.setAttr3(DataConvert.toMoney(d1));
					double d2 = bo.getAttribute("EXESSUM12").getDouble()/10000;
					extobj5.setAttr4(DataConvert.toMoney(d2));
					double d3 = bo.getAttribute("EXESSUM2").getDouble()/10000;
					extobj5.setAttr5(DataConvert.toMoney(d3));
					double d4 = bo.getAttribute("EXESSUM9").getDouble()/10000;
					extobj5.setAttr6(DataConvert.toMoney(d4));
					double d5 = bo.getAttribute("EXESSUM4").getDouble()/10000;
					extobj5.setAttr7(DataConvert.toMoney(d5));
					double d6 = bo.getAttribute("EXESSUM11").getDouble()/10000;
					extobj5.setAttr8(DataConvert.toMoney(d6));
					extobj5.setAttr2(DataConvert.toMoney(d1+d2+d3+d4+d5+d6));//开发成本
					
					extobj5.setAttr9(DataConvert.toMoney(bo.getAttribute("EXESSUM10").getDouble()/10000));
					extobj5.setAttr0(DataConvert.toMoney(bo.getAttribute("EXESSUM8").getDouble()/10000));
					
					extobj6.setAttr1(DataConvert.toMoney(bo.getAttribute("EXESSUM6").getDouble()/10000));
					extobj6.setAttr2(DataConvert.toMoney(bo.getAttribute("EXESSUM7").getDouble()/10000));
					extobj6.setAttr10(DataConvert.toMoney(bo.getAttribute("EXESSUM5").getDouble()/10000));
					
					extobj6.setAttr0(DataConvert.toMoney(bo.getAttribute("EXESSUM29").getDouble()));
					extobj7.setAttr1(DataConvert.toMoney(bo.getAttribute("EXESSUM22").getDouble()));
					extobj7.setAttr2(DataConvert.toMoney(bo.getAttribute("EXESSUM28").getDouble()));
					extobj7.setAttr3(DataConvert.toMoney(bo.getAttribute("EXESSUM13").getDouble()));
					
					extobj3.setAttr1(DataConvert.toMoney(bo.getAttribute("EXESSUM28").getDouble()));
					extobj4.setAttr9(bo.getAttribute("REDOUNDTERM").getString());
					extobj4.setAttr0(bo.getAttribute("LOANTERM").getString());
				}
				double dz1=0, dz2=0, dz3=0, dz4=0, dz5=0,dz6=0, dzall;
				//自筹资金
				m = JBOFactory.getFactory().getManager("jbo.app.PROJECT_FUNDS");
				q = m.createQuery("select sum(INVESTSUM) as V.sumz from O where projectNo=:ProjectNo and FundSource='0201'").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					dz1 = bo.getAttribute("sumz").getDouble()/10000;
					extobj6.setAttr4(DataConvert.toMoney(dz1));
				}
				//金融机构融资
				q = m.createQuery("select sum(INVESTSUM) as V.sumj from O where projectNo=:ProjectNo and FundSource='0202'").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					dz2 = bo.getAttribute("sumj").getDouble()/10000;
					extobj6.setAttr5(DataConvert.toMoney(dz2));
				}
				//预收回笼款
				q = m.createQuery("select sum(INVESTSUM) as V.sumy from O where projectNo=:ProjectNo and FundSource='0203'").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					dz3 = bo.getAttribute("sumy").getDouble()/10000;
					extobj6.setAttr6(DataConvert.toMoney(dz3));
				}
				//施工企业垫款
				q = m.createQuery("select sum(INVESTSUM) as V.sums from O where projectNo=:ProjectNo and FundSource='0204'").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					dz4 = bo.getAttribute("sums").getDouble()/10000;
					extobj6.setAttr7(DataConvert.toMoney(dz4));
				}
				//股东借款
				q = m.createQuery("select sum(INVESTSUM) as V.sumg from O where projectNo=:ProjectNo and FundSource='0205'").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					dz5 = bo.getAttribute("sumg").getDouble()/10000;
					extobj6.setAttr8(DataConvert.toMoney(dz5));
				}
				//其他资金
				q = m.createQuery("select sum(INVESTSUM) as V.sumq from O where projectNo=:ProjectNo and FundSource='0206'").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					dz6 = bo.getAttribute("sumq").getDouble()/10000;
					extobj6.setAttr9(DataConvert.toMoney(dz6));
				}
				dzall = dz1+dz2+dz3+dz4+dz5+dz6;
				extobj6.setAttr3(DataConvert.toMoney(dzall));//资金来源
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return true;
	}

	public boolean initObjectForEdit() {
		
		return true;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public String getOpinion2() {
		return opinion2;
	}

	public void setOpinion2(String opinion2) {
		this.opinion2 = opinion2;
	}

	public DocExtClass getExtobj1() {
		return extobj1;
	}

	public void setExtobj1(DocExtClass extobj1) {
		this.extobj1 = extobj1;
	}

	public DocExtClass getExtobj2() {
		return extobj2;
	}

	public void setExtobj2(DocExtClass extobj2) {
		this.extobj2 = extobj2;
	}

	public DocExtClass getExtobj3() {
		return extobj3;
	}

	public void setExtobj3(DocExtClass extobj3) {
		this.extobj3 = extobj3;
	}

	public DocExtClass getExtobj4() {
		return extobj4;
	}

	public void setExtobj4(DocExtClass extobj4) {
		this.extobj4 = extobj4;
	}

	public DocExtClass getExtobj5() {
		return extobj5;
	}

	public void setExtobj5(DocExtClass extobj5) {
		this.extobj5 = extobj5;
	}

	public DocExtClass getExtobj6() {
		return extobj6;
	}

	public void setExtobj6(DocExtClass extobj6) {
		this.extobj6 = extobj6;
	}

	public DocExtClass getExtobj7() {
		return extobj7;
	}

	public void setExtobj7(DocExtClass extobj7) {
		this.extobj7 = extobj7;
	}
	
}
