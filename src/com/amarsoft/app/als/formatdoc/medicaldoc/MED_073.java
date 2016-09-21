package com.amarsoft.app.als.formatdoc.medicaldoc;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.finance.analyse.model.ReportSubject;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.dict.als.manage.CodeManager;

/**
 * 医疗类客户财务指标表
 * @author Administrator
 *
 */
public class MED_073 extends FormatDocData implements Serializable{
	private static final long serialVersionUID = 1L;
	private DocExtClass extobj0;
    private DocExtClass extobj1;
    private DocExtClass extobj2;
    private DocExtClass extobj3;
    private DocExtClass extobj4;
    private DocExtClass extobj5;
    private DocExtClass extobj6;
    private DocExtClass extobj7;
    private DocExtClass extobj8;
    private DocExtClass extobj9;
    private DocExtClass extobj10;
    private DocExtClass extobj11;
    private DocExtClass extobj12;
    private DocExtClass extobj13;
    private DocExtClass extobj14;
    
    private String opinion1="";
    private String opinion2="";
    private String opinion3="";

	public boolean initObjectForRead() {
		ARE.getLog().trace("MED_073.initObject()");
		
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
			extobj0 = new DocExtClass();
			extobj1 = new DocExtClass();
			extobj2 = new DocExtClass();
			extobj3 = new DocExtClass();
			extobj4 = new DocExtClass();
			extobj5 = new DocExtClass();
			extobj6 = new DocExtClass();
			extobj7 = new DocExtClass();
			extobj8 = new DocExtClass();
			extobj9 = new DocExtClass();
			extobj10 = new DocExtClass();
			extobj11 = new DocExtClass();
			extobj12 = new DocExtClass();
			extobj13 = new DocExtClass();
			extobj14 = new DocExtClass();

			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				ReportSubject rs = null;
				FinanceDataManager financedata = new FinanceDataManager();
				CustomerFSRecord cfs = financedata.getNewestReport(sCustomerID);//本期
				String reportType = cfs.getFinanceBelong();
				if(cfs != null){
					if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
					Map reportMap = financedata.getGuideMap(cfs);
					rs = (ReportSubject) reportMap.get("人均业务收入");
					extobj1.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("药品收入占业务收入的比重(%)");
					extobj2.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("平均门诊人次费用");
					extobj3.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("平均住院床日费用");
					extobj4.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("平均病床收入");
					extobj5.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("病床使用率(%)");
					extobj6.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("平均药品收支结余率(%)");
					extobj7.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("平均医疗收支结余率(%)");
					extobj8.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("医疗人员水平(%)");
					extobj9.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("负债合计/收入合计");
					extobj10.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("有息债务/收支结余");
					extobj11.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("有息债务/事业基金");
					extobj12.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("短期偿债能力");
					extobj13.setAttr1(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("收支比");
					extobj14.setAttr1(rs.getCol2ValueString());
					
					CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
					if(cfs1 != null&& cfs1.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
						reportMap = financedata.getGuideMap(cfs1);
						rs = (ReportSubject) reportMap.get("人均业务收入");
						extobj1.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("药品收入占业务收入的比重(%)");
						extobj2.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均门诊人次费用");
						extobj3.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均住院床日费用");
						extobj4.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均病床收入");
						extobj5.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("病床使用率(%)");
						extobj6.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均药品收支结余率(%)");
						extobj7.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均医疗收支结余率(%)");
						extobj8.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("医疗人员水平(%)");
						extobj9.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("负债合计/收入合计");
						extobj10.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有息债务/收支结余");
						extobj11.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有息债务/事业基金");
						extobj12.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("短期偿债能力");
						extobj13.setAttr2(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("收支比");
						extobj14.setAttr2(rs.getCol2ValueString());
					}
					
					CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
					if(cfs2 != null&& cfs2.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
						reportMap = financedata.getGuideMap(cfs2);
						rs = (ReportSubject) reportMap.get("人均业务收入");
						extobj1.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("药品收入占业务收入的比重(%)");
						extobj2.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均门诊人次费用");
						extobj3.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均住院床日费用");
						extobj4.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均病床收入");
						extobj5.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("病床使用率(%)");
						extobj6.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均药品收支结余率(%)");
						extobj7.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均医疗收支结余率(%)");
						extobj8.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("医疗人员水平(%)");
						extobj9.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("负债合计/收入合计");
						extobj10.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有息债务/收支结余");
						extobj11.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有息债务/事业基金");
						extobj12.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("短期偿债能力");
						extobj13.setAttr3(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("收支比");
						extobj14.setAttr3(rs.getCol2ValueString());
					}
					
					CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年末
					if(cfs3 != null&& cfs3.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
						reportMap = financedata.getGuideMap(cfs3);
						rs = (ReportSubject) reportMap.get("人均业务收入");
						extobj1.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("药品收入占业务收入的比重(%)");
						extobj2.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均门诊人次费用");
						extobj3.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均住院床日费用");
						extobj4.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均病床收入");
						extobj5.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("病床使用率(%)");
						extobj6.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均药品收支结余率(%)");
						extobj7.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均医疗收支结余率(%)");
						extobj8.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("医疗人员水平(%)");
						extobj9.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("负债合计/收入合计");
						extobj10.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有息债务/收支结余");
						extobj11.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有息债务/事业基金");
						extobj12.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("短期偿债能力");
						extobj13.setAttr4(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("收支比");
						extobj14.setAttr4(rs.getCol2ValueString());
					}
					
					CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年末
					if(cfs4 != null&& cfs4.getFinanceBelong().equals(reportType)){
						if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
						reportMap = financedata.getGuideMap(cfs4);
						rs = (ReportSubject) reportMap.get("人均业务收入");
						extobj1.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("药品收入占业务收入的比重(%)");
						extobj2.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均门诊人次费用");
						extobj3.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均住院床日费用");
						extobj4.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均病床收入");
						extobj5.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("病床使用率(%)");
						extobj6.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均药品收支结余率(%)");
						extobj7.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("平均医疗收支结余率(%)");
						extobj8.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("医疗人员水平(%)");
						extobj9.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("负债合计/收入合计");
						extobj10.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有息债务/收支结余");
						extobj11.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("有息债务/事业基金");
						extobj12.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("短期偿债能力");
						extobj13.setAttr5(rs.getCol2ValueString());
						rs = (ReportSubject) reportMap.get("收支比");
						extobj14.setAttr5(rs.getCol2ValueString());
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 = " ";
		opinion2 = " ";
		opinion3 = " ";
		return true;
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

	public DocExtClass getExtobj7() {
		return extobj7;
	}

	public void setExtobj7(DocExtClass extobj7) {
		this.extobj7 = extobj7;
	}

	public DocExtClass getExtobj8() {
		return extobj8;
	}

	public void setExtobj8(DocExtClass extobj8) {
		this.extobj8 = extobj8;
	}

	public DocExtClass getExtobj9() {
		return extobj9;
	}

	public void setExtobj9(DocExtClass extobj9) {
		this.extobj9 = extobj9;
	}

	public DocExtClass getExtobj10() {
		return extobj10;
	}

	public void setExtobj10(DocExtClass extobj10) {
		this.extobj10 = extobj10;
	}

	public DocExtClass getExtobj11() {
		return extobj11;
	}

	public void setExtobj11(DocExtClass extobj11) {
		this.extobj11 = extobj11;
	}

	public DocExtClass getExtobj12() {
		return extobj12;
	}

	public void setExtobj12(DocExtClass extobj12) {
		this.extobj12 = extobj12;
	}

	public DocExtClass getExtobj13() {
		return extobj13;
	}

	public void setExtobj13(DocExtClass extobj13) {
		this.extobj13 = extobj13;
	}

	public DocExtClass getExtobj14() {
		return extobj14;
	}

	public void setExtobj14(DocExtClass extobj14) {
		this.extobj14 = extobj14;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}
    
}
