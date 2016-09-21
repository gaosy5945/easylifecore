package com.amarsoft.app.als.formatdoc.capitalassertdoc;

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

public class CA extends FormatDocData implements Serializable {
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
    private String opinion3 = "";
    private String opinion4 = "";
    private String opinion5 = "";

	public CA() {
	}

	public boolean initObjectForRead() {
		ARE.getLog().trace("CA.initObject()");
		extobj1 = new DocExtClass();
		extobj2 = new DocExtClass();
		extobj3 = new DocExtClass();
		extobj4 = new DocExtClass();
		extobj5 = new DocExtClass();
		extobj6 = new DocExtClass();
		extobj7 = new DocExtClass();
		
		String sObjectNo=this.getRecordObjectNo();
		String sObjectType=this.getRecordObjectType();
		if(sObjectNo==null)sObjectNo="";
		if(sObjectType==null)sObjectType="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String sApplyType=null;
		String customerID = "";
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			if(bo != null){
				customerID = bo.getAttribute("CustomerID").getString();
				sApplyType= bo.getAttribute("ApplyType").getString();
			}
			if(customerID!=null&& !"".equals(customerID)){
				String projectNo = "";
				m = JBOFactory.getFactory().getManager("jbo.app.PROJECT_INFO");
				if("CESingleApply".equals(sApplyType)){
					q = m.createQuery("select * from O where O.projectType='01' and O.projectno in (select pr.PROJECTNO from jbo.app.PROJECT_RELATIVE pr where pr.objectType='CreditApply' and pr.ObjectNo=:ObjectNo) order by O.projectno desc").setParameter("ObjectNo",sObjectNo);
				}else{
					q = m.createQuery("select * from O where O.projectType='01' and O.projectno in (select pr.PROJECTNO from jbo.app.PROJECT_RELATIVE pr where pr.objectType='Customer' and pr.ObjectNo=:CustomerID) order by O.projectno desc").setParameter("CustomerID",customerID);
				}
				
				bo = q.getSingleResult();
				if(bo != null){
					projectNo = bo.getAttribute("ProjectNo").getString();
					extobj1.setAttr1(bo.getAttribute("ProjectName").getString());
					String projectType = bo.getAttribute("ProjectType").getString();
					extobj1.setAttr2(CodeManager.getItemName("ProjectStyle", projectType));
					String projectSub = bo.getAttribute("ProjectSubType").getString();
					extobj1.setAttr3(CodeManager.getItemName("ProjectSubType",projectSub));
					extobj1.setAttr4(bo.getAttribute("ChieflyProduct").getString());
					extobj1.setAttr5(bo.getAttribute("DEVELOPMENTNAME").getString());
					extobj1.setAttr6(bo.getAttribute("COPARTNERNAME").getString());
					extobj1.setAttr7(bo.getAttribute("COPARTNERID").getString());
					extobj1.setAttr8(bo.getAttribute("LICENCE1").getString());
					extobj1.setAttr9(bo.getAttribute("LICENCE2").getString());
					extobj1.setAttr0(bo.getAttribute("LICENCE3").getString());
					extobj2.setAttr1(bo.getAttribute("LICENCE4").getString());
					extobj2.setAttr2(bo.getAttribute("SUPERVISORINFO").getString());
					extobj2.setAttr3(bo.getAttribute("LICENCE5").getString());
					extobj2.setAttr4(bo.getAttribute("LICENCE6").getString());
					extobj2.setAttr6(DataConvert.toMoney(bo.getAttribute("PlanTotalCast").getDouble()/10000));
					extobj2.setAttr7(DataConvert.toMoney(bo.getAttribute("CapitalAssertsCast").getDouble()/10000));
					extobj2.setAttr8(DataConvert.toMoney(bo.getAttribute("Fund").getDouble()/10000));
					extobj2.setAttr9(DataConvert.toMoney(bo.getAttribute("ProjectCapital").getDouble()/10000));
					extobj2.setAttr0(bo.getAttribute("CapitalScale").getString());
					
					extobj3.setAttr4(bo.getAttribute("BEGINBUILDDATE").getString());
					extobj3.setAttr5(bo.getAttribute("EXPECTCOMPLETEDATE").getString());
				}
				m = JBOFactory.getFactory().getManager("jbo.app.PROJECT_PROGRESS");
				q = m.createQuery("ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					extobj3.setAttr1(DataConvert.toMoney(bo.getAttribute("INVESTEDSUM").getDouble()/10000));
					extobj3.setAttr2(bo.getAttribute("SUM2").getString());
				}
				
				m = JBOFactory.getFactory().getManager("jbo.app.PROJECT_BUDGET");
				q = m.createQuery("ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					double d1 = bo.getAttribute("EXESSUM2").getDouble()/10000;
					extobj3.setAttr6(DataConvert.toMoney(d1));
					double d2 = bo.getAttribute("EXESSUM1").getDouble()/10000;
					extobj3.setAttr7(DataConvert.toMoney(d2));
					double d3 = bo.getAttribute("EXESSUM3").getDouble()/10000;
					extobj3.setAttr8(DataConvert.toMoney(d3));
					double d4 = bo.getAttribute("EXESSUM5").getDouble()/10000;
					extobj3.setAttr9(DataConvert.toMoney(d4));
					double d5 = bo.getAttribute("EXESSUM7").getDouble()/10000;
					extobj3.setAttr0(DataConvert.toMoney(d5));
					double d6 = bo.getAttribute("EXESSUM6").getDouble()/10000;
					extobj4.setAttr1(DataConvert.toMoney(d6));
					double d7 = bo.getAttribute("EXESSUM11").getDouble()/10000;
					extobj4.setAttr2(DataConvert.toMoney(d7));
					double d8 = bo.getAttribute("EXESSUM9").getDouble()/10000;
					extobj4.setAttr3(DataConvert.toMoney(d8));
					double d9 = bo.getAttribute("EXESSUM10").getDouble()/10000;
					extobj4.setAttr4(DataConvert.toMoney(d9));
					double d10 = bo.getAttribute("EXESSUM4").getDouble()/10000;
					extobj4.setAttr5(DataConvert.toMoney(d10));
					double litt = d1+d2+d3+d4+d5+d6+d7+d8+d9+d10;
					extobj4.setAttr6(DataConvert.toMoney(litt));
					double flo = bo.getAttribute("EXESSUM24").getDouble()/10000;
					extobj4.setAttr7(DataConvert.toMoney(flo));
					extobj4.setAttr8(DataConvert.toMoney(litt+flo));
					
					extobj7.setAttr1(bo.getAttribute("EXESSUM28").getString());
					extobj7.setAttr2(bo.getAttribute("EXESSUM14").getString());
					extobj7.setAttr3(DataConvert.toMoney(bo.getAttribute("EXESSUM16").getDouble()/10000));
					extobj7.setAttr4(bo.getAttribute("EXESSUM17").getString());
					extobj7.setAttr5(bo.getAttribute("REDOUNDTERM").getString());
					extobj7.setAttr6(bo.getAttribute("LOANTERM").getString());
				}
				double zhsum=0,zfsum=0,chsum=0,cfsum=0;
				m = JBOFactory.getFactory().getManager("jbo.app.PROJECT_FUNDS");
				//资本金    货币方式
				q = m.createQuery("select sum(INVESTSUM) as V.zhsum from O where O.LOCATIONOFINVESTOR='01' and O.FUNDSOURCE='0101' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					zhsum = bo.getAttribute("zhsum").getDouble()/10000;
					
				}
				//资本金  非货币方式
				q = m.createQuery("select sum(INVESTSUM) as V.zfsum from O where O.LOCATIONOFINVESTOR='02' and O.FUNDSOURCE='0101' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					zfsum = bo.getAttribute("zfsum").getDouble()/10000;
				}
				//自筹  货币方式
				q = m.createQuery("select sum(INVESTSUM) as V.chsum from O where O.LOCATIONOFINVESTOR='01' and O.FUNDSOURCE='0102' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					chsum = bo.getAttribute("chsum").getDouble()/10000;
				}
				//自筹   非货币方式
				q = m.createQuery("select sum(INVESTSUM) as V.cfsum from O where O.LOCATIONOFINVESTOR='02' and O.FUNDSOURCE='0102' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					cfsum = bo.getAttribute("cfsum").getDouble()/10000;
				}
				extobj5.setAttr1(DataConvert.toMoney(zhsum+chsum));
				extobj5.setAttr3(DataConvert.toMoney(zfsum+cfsum));
				extobj5.setAttr5(DataConvert.toMoney(zhsum+chsum+zfsum+cfsum));
//				extobj5.setAttr6(DataConvert.toMoney(chsum+cfsum));
				extobj5.setAttr7(DataConvert.toMoney(zhsum+zfsum+chsum+cfsum));
				
				double shortsum=0,middsum=0,longsum=0,rongzsum=0,zhaiqsum=0,othersum=0;
				//短期借款
				q = m.createQuery("select sum(INVESTSUM) as V.shortsum from O where O.RESPONDTYPE='01' and O.FUNDSOURCE='0103' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					shortsum = bo.getAttribute("shortsum").getDouble()/10000;
					extobj5.setAttr8(DataConvert.toMoney(shortsum));
				}
				//中期借款
				q = m.createQuery("select sum(INVESTSUM) as V.middsum from O where O.RESPONDTYPE='02' and O.FUNDSOURCE='0103' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					middsum = bo.getAttribute("middsum").getDouble()/10000;
					extobj5.setAttr9(DataConvert.toMoney(middsum));
				}
				//长期借款
				q = m.createQuery("select sum(INVESTSUM) as V.longsum from O where O.RESPONDTYPE='03' and O.FUNDSOURCE='0103' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					longsum = bo.getAttribute("longsum").getDouble()/10000;
					extobj5.setAttr0(DataConvert.toMoney(longsum));
				}
				//融资租赁
				q = m.createQuery("select sum(INVESTSUM) as V.rongzsum from O where O.RESPONDTYPE='04' and O.FUNDSOURCE='0103' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					rongzsum = bo.getAttribute("rongzsum").getDouble()/10000;
					extobj6.setAttr1(DataConvert.toMoney(rongzsum));
				}
				extobj6.setAttr2(DataConvert.toMoney(shortsum+middsum+longsum+rongzsum));
				//企业债券
				q = m.createQuery("select sum(INVESTSUM) as V.zhaiqsum from O where O.FUNDSOURCE='0104' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					zhaiqsum = bo.getAttribute("zhaiqsum").getDouble()/10000;
					extobj6.setAttr3(DataConvert.toMoney(zhaiqsum));
				}
				//其他负债
				q = m.createQuery("select sum(INVESTSUM) as V.othersum from O where O.FUNDSOURCE='0105' and ProjectNo=:ProjectNo").setParameter("ProjectNo", projectNo);
				bo = q.getSingleResult();
				if(bo != null){
					othersum = bo.getAttribute("othersum").getDouble()/10000;
					extobj6.setAttr4(DataConvert.toMoney(othersum));
				}
				extobj6.setAttr5(DataConvert.toMoney(shortsum+middsum+longsum+rongzsum+zhaiqsum+othersum+zhsum+chsum+zfsum+cfsum));
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

	public String getOpinion3() {
		return opinion3;
	}

	public void setOpinion3(String opinion3) {
		this.opinion3 = opinion3;
	}

	public String getOpinion4() {
		return opinion4;
	}

	public void setOpinion4(String opinion4) {
		this.opinion4 = opinion4;
	}

	public String getOpinion5() {
		return opinion5;
	}

	public void setOpinion5(String opinion5) {
		this.opinion5 = opinion5;
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
