package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.FileInputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.finance.analyse.model.ReportSubject;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.app.als.guaranty.model.GuarantyConst;
import com.amarsoft.biz.formatdoc.model.FormatDocData;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.manage.NameManager;

public class CR_081_05 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
	
	//利润表
    private DocExtClass extobjl0;//此处为L的小写
    private DocExtClass extobjl1;
    private DocExtClass extobjl2;
    private DocExtClass extobjl3;
    private DocExtClass extobjl4;
    private DocExtClass extobjl5;
    private DocExtClass extobjl6;
    private DocExtClass extobjl7;
    private DocExtClass extobjl8;
    private DocExtClass extobjl9;
    private DocExtClass extobjl10;
    private DocExtClass extobjl11;
    private DocExtClass extobjl12;
    private DocExtClass extobjl13;
    private DocExtClass extobjl14;
    private DocExtClass extobjl15;
    private DocExtClass extobjl16;
    private DocExtClass extobjl17;
    private DocExtClass extobjl18;
    private DocExtClass extobjl19;
    private DocExtClass extobjl20;
    private DocExtClass extobjl21;
    private DocExtClass extobjl22;
    private DocExtClass extobjl23;
    private DocExtClass extobjl24;
    private DocExtClass extobjl25;
    private DocExtClass extobjl26;
    
    private DocExtClass extobjl27;
    private DocExtClass extobjl28;
    private DocExtClass extobjl29;
    private DocExtClass extobjl30;
    private DocExtClass extobjl31;
    private DocExtClass extobjl32;
    private DocExtClass extobjl33;
    private DocExtClass extobjl34;
    private DocExtClass extobjl35;
    private DocExtClass extobjl36;
    private String opinion1="";
	private String sFinancelType = "";
	//其他事业单位
	private String opinion="";
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
    private DocExtClass extobj15;
    private DocExtClass extobj16;
    private DocExtClass extobj17;
    private DocExtClass extobj18;
    private DocExtClass extobj19;
    private DocExtClass extobj20;
    private DocExtClass extobj21;
    private DocExtClass extobj22;
    
    //医疗类报告分析
    private DocExtClass extobj23;
    private DocExtClass extobj24;
    private DocExtClass extobj25;
	private String opinion2="";
    private DocExtClass ext0;
    private DocExtClass ext1;
    private DocExtClass ext2;
    private DocExtClass ext3;
    private DocExtClass ext4;
    private DocExtClass ext5;
    private DocExtClass ext6;
    private DocExtClass ext7;
    private DocExtClass ext8;
    private DocExtClass ext9;
    private DocExtClass ext10;
    private DocExtClass ext11;
    private DocExtClass ext12;
    private DocExtClass ext13;
    private DocExtClass ext14;
    private DocExtClass ext15;
    private DocExtClass ext16;
    private DocExtClass ext17;
    private DocExtClass ext18;
    private DocExtClass ext19;
    private DocExtClass ext20;
    private DocExtClass ext21;
    private DocExtClass ext22;
    private DocExtClass ext23;
    private DocExtClass ext24;
    private DocExtClass ext25;
    
	BizObjectManager m = null;
	BizObjectQuery q = null;
	BizObject bo = null;
	String customerID = "";
	public CR_081_05() {
	}

	public boolean initObjectForRead() {
		
		extobjl0 = new DocExtClass();
		extobjl1 = new DocExtClass();
		extobjl2 = new DocExtClass();
		extobjl3 = new DocExtClass();
		extobjl4 = new DocExtClass();
		extobjl5 = new DocExtClass();
		extobjl6 = new DocExtClass();
		extobjl7 = new DocExtClass();
		extobjl8 = new DocExtClass();
		extobjl9 = new DocExtClass();
		extobjl10 = new DocExtClass();
		extobjl11 = new DocExtClass();
		extobjl12 = new DocExtClass();
		extobjl13 = new DocExtClass();
		extobjl14 = new DocExtClass();
		extobjl15 = new DocExtClass();
		extobjl16 = new DocExtClass();
		extobjl17 = new DocExtClass();
		extobjl18 = new DocExtClass();
		extobjl19 = new DocExtClass();
		extobjl20 = new DocExtClass();
		extobjl21 = new DocExtClass();
		extobjl22 = new DocExtClass();
		extobjl23 = new DocExtClass();
		extobjl24 = new DocExtClass();
		extobjl25 = new DocExtClass();
		extobjl26 = new DocExtClass();
		extobjl27 = new DocExtClass();
		extobjl28 = new DocExtClass();
		extobjl29 = new DocExtClass();
		extobjl30 = new DocExtClass();
		extobjl31 = new DocExtClass();
		extobjl32 = new DocExtClass();
		extobjl33 = new DocExtClass();
		extobjl34 = new DocExtClass();
		extobjl35 = new DocExtClass();
		extobjl36 = new DocExtClass();
		//其他事业单位报表
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
		extobj15 = new DocExtClass();
		extobj16 = new DocExtClass();
		extobj17 = new DocExtClass();
		extobj18 = new DocExtClass();
		extobj19 = new DocExtClass();
		extobj20 = new DocExtClass();
		extobj21 = new DocExtClass();
		extobj22 = new DocExtClass();
		
		//医疗类分析报告
		extobj23 = new DocExtClass();
		extobj24 = new DocExtClass();
		extobj25 = new DocExtClass();
		
		ext0 = new DocExtClass();
		ext1 = new DocExtClass();
		ext2 = new DocExtClass();
		ext3 = new DocExtClass();
		ext4 = new DocExtClass();
		ext5 = new DocExtClass();
		ext6 = new DocExtClass();
		ext7 = new DocExtClass();
		ext8 = new DocExtClass();
		ext9 = new DocExtClass();
		ext10 = new DocExtClass();
		ext11 = new DocExtClass();
		ext12 = new DocExtClass();
		ext13 = new DocExtClass();
		ext14 = new DocExtClass();
		ext15 = new DocExtClass();
		ext16 = new DocExtClass();
		ext17 = new DocExtClass();
		ext18 = new DocExtClass();
		ext19 = new DocExtClass();
		ext20 = new DocExtClass();
		ext21 = new DocExtClass();
		ext22 = new DocExtClass();
		ext23 = new DocExtClass();
		ext24 = new DocExtClass();
		ext25 = new DocExtClass();
		
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		String guarantyNo = this.getGuarantyNo();	
		if(guarantyNo==null)guarantyNo="";
		try {
			if(guarantyNo!=null&& !"".equals(guarantyNo)){
				m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
				q = m.createQuery("GuarantyID=:GuarantyID").setParameter("GuarantyID", guarantyNo);
				bo = q.getSingleResult();
				if(bo != null){
					customerID = bo.getAttribute("COLASSETOWNER").getString();
				}
			}
			if(!StringX.isSpace(customerID)){
				sFinancelType = getReportType(customerID);
				if("010".equals(sFinancelType)){
					getNew();
				}else if("020".equals(sFinancelType)){
					getOld();
				}else if(sFinancelType.equals("160")){
					getAssure();
				}else if(sFinancelType.equals("030")){
					getOE();
				}else if("050".equals(sFinancelType)){
					getMED();
				}else if("040".equals(sFinancelType)){
					getED();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean initObjectForEdit() {
		return true;
	}

	public void setModelInputStream()throws Exception{
		
		//String sFinancelType = "010";//以新会计准则为例
		try{
			if(sFinancelType.equals("010"))
			{
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_new_05.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_new_05.html");//templateFileName+"_new.html"文件要存在
			}else if(sFinancelType.equals("020")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_05.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_05.html");//templateFileName+"_old.html"文件要存在
			}else if(sFinancelType.equals("160")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_assure_05.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_assure_05.html");
			}else if(sFinancelType.equals("030")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_OE_05.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_OE_05.html");
			}else if(sFinancelType.equals("050")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_MED_05.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_MED_05.html");
			}else if(sFinancelType.equals("040")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_ED_05.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_ED_05.html");
			}else{
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/Blank_000.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/Blank_000.html");//templateFileName+"_old.html"文件要存在
			}
		}
		catch(Exception e){
			throw new Exception("没有找到模板文件：" + e.toString());
		}
	}
	
	public String getReportType(String CustomerID) throws JBOException{
		String sReturn = "";
		
		FinanceDataManager fdm = new FinanceDataManager();
		CustomerFSRecord cfs = fdm.getNewestReport(CustomerID);
		if(cfs != null){
			sReturn = cfs.getFinanceBelong();
		}else {
			sReturn = "";
		}
		return sReturn;
	}
	
	//教育类
	public void getED(){
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//本期
		String reportType = cfs.getFinanceBelong();
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getLossMap(cfs);
			rs = (ReportSubject) reportMap.get("教育经费拨款");
			extobj1.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("科研经费拨款");
			extobj2.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("其他经费拨款");
			extobj3.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("上级补助收入");
			extobj4.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("教育事业收入");
			extobj5.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("科研事业收入");
			extobj6.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("经营收入");
			extobj7.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("附属单位缴款");
			extobj8.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("其他收入");
			extobj9.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("教育附加拨款");
			extobj10.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("拨入专款");
			extobj11.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("收入合计");
			extobj12.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("拨出经费");
			extobj13.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("教育事业支出");
			extobj14.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("科研事业支出");
			extobj15.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("上缴上级支出");
			extobj16.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("其他事业支出");
			extobj17.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("对附属单位补助");
			extobj18.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("结转自筹基建");
			extobj19.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("经营支出");
			extobj20.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("自筹基建支出");
			extobj21.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("支出合计");
			extobj22.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("收支差额");
			extobj23.setAttr1(rs.getCol2IntString());
			
			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
			if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
				double d1;
				reportMap = financedata.getLossMap(cfs1);
				rs = (ReportSubject) reportMap.get("教育经费拨款");
				extobj1.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj1.setAttr6(String.format("%.2f",d1));
				}else {
					extobj1.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("科研经费拨款");
				extobj2.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj2.setAttr6(String.format("%.2f",d1));
				}else {
					extobj2.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其他经费拨款");
				extobj3.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj3.setAttr6(String.format("%.2f",d1));
				}else {
					extobj3.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj4.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj4.setAttr6(String.format("%.2f",d1));
				}else {
					extobj4.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("教育事业收入");
				extobj5.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj5.setAttr6(String.format("%.2f",d1));
				}else {
					extobj5.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("科研事业收入");
				extobj6.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj6.setAttr6(String.format("%.2f",d1));
				}else {
					extobj6.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("经营收入");
				extobj7.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj7.setAttr6(String.format("%.2f",d1));
				}else {
					extobj7.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("附属单位缴款");
				extobj8.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj8.setAttr6(String.format("%.2f",d1));
				}else {
					extobj8.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj9.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj9.setAttr6(String.format("%.2f",d1));
				}else {
					extobj9.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("教育附加拨款");
				extobj10.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj10.setAttr6(String.format("%.2f",d1));
				}else {
					extobj10.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj11.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj11.setAttr6(String.format("%.2f",d1));
				}else {
					extobj11.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj12.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj12.setAttr6(String.format("%.2f",d1));
				}else {
					extobj12.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("拨出经费");
				extobj13.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj13.setAttr6(String.format("%.2f",d1));
				}else {
					extobj13.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("教育事业支出");
				extobj14.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj14.setAttr6(String.format("%.2f",d1));
				}else {
					extobj14.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("科研事业支出");
				extobj15.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj15.setAttr6(String.format("%.2f",d1));
				}else {
					extobj15.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("上缴上级支出");
				extobj16.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj16.setAttr6(String.format("%.2f",d1));
				}else {
					extobj16.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其他事业支出");
				extobj17.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj17.setAttr6(String.format("%.2f",d1));
				}else {
					extobj17.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj18.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj18.setAttr6(String.format("%.2f",d1));
				}else {
					extobj18.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("结转自筹基建");
				extobj19.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj19.setAttr6(String.format("%.2f",d1));
				}else {
					extobj19.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("经营支出");
				extobj20.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj20.setAttr6(String.format("%.2f",d1));
				}else {
					extobj20.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("自筹基建支出");
				extobj21.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj21.setAttr6(String.format("%.2f",d1));
				}else {
					extobj21.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj22.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj22.setAttr6(String.format("%.2f",d1));
				}else {
					extobj22.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("收支差额");
				extobj23.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj23.setAttr6(String.format("%.2f",d1));
				}else {
					extobj23.setAttr6("");
				}
			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
			if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs2);
				rs = (ReportSubject) reportMap.get("教育经费拨款");
				extobj1.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("科研经费拨款");
				extobj2.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他经费拨款");
				extobj3.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj4.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("教育事业收入");
				extobj5.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("科研事业收入");
				extobj6.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营收入");
				extobj7.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("附属单位缴款");
				extobj8.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj9.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("教育附加拨款");
				extobj10.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj11.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj12.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨出经费");
				extobj13.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("教育事业支出");
				extobj14.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("科研事业支出");
				extobj15.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("上缴上级支出");
				extobj16.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他事业支出");
				extobj17.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj18.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("结转自筹基建");
				extobj19.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营支出");
				extobj20.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("自筹基建支出");
				extobj21.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj22.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收支差额");
				extobj23.setAttr3(rs.getCol2IntString());
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年年末
			if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs3);
				rs = (ReportSubject) reportMap.get("教育经费拨款");
				extobj1.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("科研经费拨款");
				extobj2.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他经费拨款");
				extobj3.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj4.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("教育事业收入");
				extobj5.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("科研事业收入");
				extobj6.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营收入");
				extobj7.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("附属单位缴款");
				extobj8.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj9.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("教育附加拨款");
				extobj10.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj11.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj12.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨出经费");
				extobj13.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("教育事业支出");
				extobj14.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("科研事业支出");
				extobj15.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("上缴上级支出");
				extobj16.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他事业支出");
				extobj17.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj18.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("结转自筹基建");
				extobj19.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营支出");
				extobj20.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("自筹基建支出");
				extobj21.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj22.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收支差额");
				extobj23.setAttr4(rs.getCol2IntString());
			}
			
			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年年末
			if(cfs4 != null && cfs4.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs4);
				rs = (ReportSubject) reportMap.get("教育经费拨款");
				extobj1.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("科研经费拨款");
				extobj2.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他经费拨款");
				extobj3.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj4.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("教育事业收入");
				extobj5.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("科研事业收入");
				extobj6.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营收入");
				extobj7.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("附属单位缴款");
				extobj8.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj9.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("教育附加拨款");
				extobj10.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj11.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj12.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨出经费");
				extobj13.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("教育事业支出");
				extobj14.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("科研事业支出");
				extobj15.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("上缴上级支出");
				extobj16.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他事业支出");
				extobj17.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj18.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("结转自筹基建");
				extobj19.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("经营支出");
				extobj20.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("自筹基建支出");
				extobj21.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj22.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收支差额");
				extobj23.setAttr5(rs.getCol2IntString());
			}
		}
	}

	//医疗类报告分析
	
	public void getMED(){
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//本期
		String reportType = cfs.getFinanceBelong();
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getLossMap(cfs);
			rs = (ReportSubject) reportMap.get("财政补助收入");
			extobj1.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("其中：专项补助");
			extobj2.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("上级补助收入");
			extobj3.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("医疗收入");
			extobj4.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("药品收入");
			extobj5.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("其他收入");
			extobj6.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("拨入专款");
			extobj7.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("收入合计");
			extobj8.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("医疗支出");
			extobj9.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("药品支出");
			extobj10.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("对附属单位补助");
			extobj11.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("财政专项支出");
			extobj12.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("拨出专款");
			extobj13.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("其他支出");
			extobj14.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("自筹基建支出");
			extobj15.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("支出合计");
			extobj16.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("收支结余");
			extobj17.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
			extobj18.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
			extobj19.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("结余分配");
			extobj20.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("减：应缴超收款");
			extobj21.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("加：年初待分配结余");
			extobj22.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
			extobj23.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("减：转入事业基金");
			extobj24.setAttr1(rs.getCol2IntString());
			rs = (ReportSubject) reportMap.get("期末待分配结余");
			extobj25.setAttr1(rs.getCol2IntString());
			
			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
			if(cfs1 != null&& cfs1.getFinanceBelong().equals(reportType)){
				double d1;
				if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs1);
				rs = (ReportSubject) reportMap.get("财政补助收入");
				extobj1.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj1.setAttr6(String.format("%.2f",d1));
				}else {
					extobj1.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其中：专项补助");
				extobj2.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj2.setAttr6(String.format("%.2f",d1));
				}else {
					extobj2.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj3.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj3.setAttr6(String.format("%.2f",d1));
				}else {
					extobj3.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("医疗收入");
				extobj4.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj4.setAttr6(String.format("%.2f",d1));
				}else {
					extobj4.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("药品收入");
				extobj5.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj5.setAttr6(String.format("%.2f",d1));
				}else {
					extobj5.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj6.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj6.setAttr6(String.format("%.2f",d1));
				}else {
					extobj6.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj7.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj7.setAttr6(String.format("%.2f",d1));
				}else {
					extobj7.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj8.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj8.setAttr6(String.format("%.2f",d1));
				}else {
					extobj8.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("医疗支出");
				extobj9.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj9.setAttr6(String.format("%.2f",d1));
				}else {
					extobj9.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("药品支出");
				extobj10.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj10.setAttr6(String.format("%.2f",d1));
				}else {
					extobj10.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj11.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj11.setAttr6(String.format("%.2f",d1));
				}else {
					extobj11.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("财政专项支出");
				extobj12.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj12.setAttr6(String.format("%.2f",d1));
				}else {
					extobj12.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("拨出专款");
				extobj13.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj13.setAttr6(String.format("%.2f",d1));
				}else {
					extobj13.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其他支出");
				extobj14.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj14.setAttr6(String.format("%.2f",d1));
				}else {
					extobj14.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("自筹基建支出");
				extobj15.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj15.setAttr6(String.format("%.2f",d1));
				}else {
					extobj15.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj16.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj16.setAttr6(String.format("%.2f",d1));
				}else {
					extobj16.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("收支结余");
				extobj17.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj17.setAttr6(String.format("%.2f",d1));
				}else {
					extobj17.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
				extobj18.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj18.setAttr6(String.format("%.2f",d1));
				}else {
					extobj18.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
				extobj19.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj19.setAttr6(String.format("%.2f",d1));
				}else {
					extobj19.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("结余分配");
				extobj20.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj20.setAttr6(String.format("%.2f",d1));
				}else {
					extobj20.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：应缴超收款");
				extobj21.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj21.setAttr6(String.format("%.2f",d1));
				}else {
					extobj21.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：年初待分配结余");
				extobj22.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj22.setAttr6(String.format("%.2f",d1));
				}else {
					extobj22.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
				extobj23.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj23.setAttr6(String.format("%.2f",d1));
				}else {
					extobj23.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：转入事业基金");
				extobj24.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj24.setAttr6(String.format("%.2f",d1));
				}else {
					extobj24.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("期末待分配结余");
				extobj25.setAttr2(rs.getCol2IntString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
					extobj25.setAttr6(String.format("%.2f",d1));
				}else {
					extobj25.setAttr6("");
				}
			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
			if(cfs2 != null&& cfs2.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs2);
				rs = (ReportSubject) reportMap.get("财政补助收入");
				extobj1.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：专项补助");
				extobj2.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj3.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("医疗收入");
				extobj4.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("药品收入");
				extobj5.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj6.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj7.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj8.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("医疗支出");
				extobj9.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("药品支出");
				extobj10.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj11.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财政专项支出");
				extobj12.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨出专款");
				extobj13.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他支出");
				extobj14.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("自筹基建支出");
				extobj15.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj16.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收支结余");
				extobj17.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
				extobj18.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
				extobj19.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("结余分配");
				extobj20.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：应缴超收款");
				extobj21.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：年初待分配结余");
				extobj22.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
				extobj23.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：转入事业基金");
				extobj24.setAttr3(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("期末待分配结余");
				extobj25.setAttr3(rs.getCol2IntString());
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年年末
			if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs3);
				rs = (ReportSubject) reportMap.get("财政补助收入");
				extobj1.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：专项补助");
				extobj2.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj3.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("医疗收入");
				extobj4.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("药品收入");
				extobj5.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj6.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj7.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj8.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("医疗支出");
				extobj9.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("药品支出");
				extobj10.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj11.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财政专项支出");
				extobj12.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨出专款");
				extobj13.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他支出");
				extobj14.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("自筹基建支出");
				extobj15.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj16.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收支结余");
				extobj17.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
				extobj18.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
				extobj19.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("结余分配");
				extobj20.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：应缴超收款");
				extobj21.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：年初待分配结余");
				extobj22.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
				extobj23.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：转入事业基金");
				extobj24.setAttr4(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("期末待分配结余");
				extobj25.setAttr4(rs.getCol2IntString());
			}
			
			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年年末
			if(cfs4 != null&& cfs4.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs4);
				rs = (ReportSubject) reportMap.get("财政补助收入");
				extobj1.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其中：专项补助");
				extobj2.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj3.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("医疗收入");
				extobj4.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("药品收入");
				extobj5.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj6.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj7.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj8.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("医疗支出");
				extobj9.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("药品支出");
				extobj10.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj11.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("财政专项支出");
				extobj12.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("拨出专款");
				extobj13.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("其他支出");
				extobj14.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("自筹基建支出");
				extobj15.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj16.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("收支结余");
				extobj17.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：财政专项补助结余");
				extobj18.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：事业基金弥补亏损");
				extobj19.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("结余分配");
				extobj20.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：应缴超收款");
				extobj21.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("加：年初待分配结余");
				extobj22.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：提出职工福利基金");
				extobj23.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("减：转入事业基金");
				extobj24.setAttr5(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("期末待分配结余");
				extobj25.setAttr5(rs.getCol2IntString());
			}
		}
	}
	
	public void getOld(){
		//旧会计准则报表
		ReportSubject rs = null;
		String reportType = "";
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//本期
		if(cfs != null){
			reportType = cfs.getFinanceBelong();
		//损益表
		if(!StringX.isSpace(cfs.getReportDate()))extobjl0.setAttr1("("+cfs.getReportDate()+")");
		Map reportMap = financedata.getAllSubject(cfs);
		if(reportMap.size()>0){
			rs = (ReportSubject) reportMap.get("301");//一、主营业务收入
			if(rs!=null){
				extobjl1.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("302");//减：折扣与折让
			if(rs!=null){
				extobjl2.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("304");//二、主营业务收入净额
			if(rs!=null){
				extobjl3.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("303");//主营业务成本
			if(rs!=null){
				extobjl4.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("305");//减：主营业务税金及附加
			if(rs!=null){
				extobjl5.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("308");//三、主营业务利润
			if(rs!=null){
				extobjl6.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("310");//加：其他业务利润
			if(rs!=null){
				extobjl7.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("312");//减：存货跌价损失
			if(rs!=null){
				extobjl8.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("314");//营业费用
			if(rs!=null){
				extobjl9.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("309");//管理费用
			if(rs!=null){
				extobjl10.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("311");//财务费用(含汇兑损益)
			if(rs!=null){
				extobjl11.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("307");//销售费用
			if(rs!=null){
				extobjl12.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("321");//四、营业利润
			if(rs!=null){
				extobjl13.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("317");//加：投资收益
			if(rs!=null){
				extobjl14.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("316");//补贴收入
			if(rs!=null){
				extobjl15.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("323");//营业外收入 
			if(rs!=null){
				extobjl16.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("325");//减：营业外支出
			if(rs!=null){
				extobjl17.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("324");//加：以前年度损益调整
			if(rs!=null){
				extobjl18.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("329");//五、利润总额
			if(rs!=null){
				extobjl19.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("331");//减：所得税
			if(rs!=null){
				extobjl20.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("328");//少数股东损益
			if(rs!=null){
				extobjl21.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("330");//加：未确认的投资损失
			if(rs!=null){
				extobjl22.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("332");//加：财政返还(含所得税返还)
			if(rs!=null){
				extobjl23.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("333");//六、净利润
			if(rs!=null){
				extobjl24.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("341");//应付优先股股利
			if(rs!=null){
				extobjl25.setAttr1(rs.getCol2IntString());
			}
			rs = (ReportSubject) reportMap.get("343");//应付普通股股利
			if(rs!=null){
				extobjl26.setAttr1(rs.getCol2IntString());
			}
		}
		
		CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
		if(cfs1 != null ){
			if(!StringX.isSpace(cfs1.getReportDate()))extobjl0.setAttr2("("+cfs1.getReportDate()+")");
			double d1;
			reportMap = financedata.getAllSubject(cfs1);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("301");
				if(rs!=null){
					extobjl1.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl1.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl1.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl1.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("302");
				if(rs!=null){
					extobjl2.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl2.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl2.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl2.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("304");
				if(rs!=null){
					extobjl3.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl3.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl3.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl3.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("303");
				if(rs!=null){
					extobjl4.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl4.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl4.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl4.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("305");if(rs!=null){
					extobjl5.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl5.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl5.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl5.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("308");
				if(rs!=null){
					extobjl6.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl6.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl6.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl6.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("310");
				if(rs!=null){
					extobjl7.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl7.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl7.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl7.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("312");
				if(rs!=null){
					extobjl8.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl8.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl8.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl8.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("314");
				if(rs!=null){
					extobjl9.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl9.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl9.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl9.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("309");
				if(rs!=null){
					extobjl10.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl10.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl10.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl10.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("311");
				if(rs!=null){
					extobjl11.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl11.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl11.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl11.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("307");
				if(rs!=null){
					extobjl12.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl12.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl12.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl12.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("321");
				if(rs!=null){
					extobjl13.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl13.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl13.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl13.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("317");
				if(rs!=null){
					extobjl14.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl14.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl14.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl14.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("316");
				if(rs!=null){
					extobjl15.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl15.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl15.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl15.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("323");
				if(rs!=null){
					extobjl16.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl16.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl16.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl16.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("325");
				if(rs!=null){
					extobjl17.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl17.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl17.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl17.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("324");
				if(rs!=null){
					extobjl18.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl18.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl18.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl18.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("329");
				if(rs!=null){
					extobjl19.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl19.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl19.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl19.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("331");
				if(rs!=null){
					extobjl20.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl20.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl20.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl20.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("328");
				if(rs!=null){
					extobjl21.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl21.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl21.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl21.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("330");
				if(rs!=null){
					extobjl22.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl22.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl22.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl22.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("332");
				if(rs!=null){
					extobjl23.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl23.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl23.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl23.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("333");
				if(rs!=null){
					extobjl24.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl24.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl24.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl24.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("341");
				if(rs!=null){
					extobjl25.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl25.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl25.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl25.setAttr6("");
					}
				}
				rs = (ReportSubject) reportMap.get("343");
				if(rs!=null){
					extobjl26.setAttr2(rs.getCol2IntString());
					if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl26.getAttr1()!=null){
						d1 = (Double.parseDouble(extobjl26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
						extobjl26.setAttr6(String.format("%.0f",d1*100));
					}else {
						extobjl26.setAttr6("");
					}
				}
			}
		}
		
		CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
		if(cfs2 != null ){
			if(!StringX.isSpace(cfs2.getReportDate()))extobjl0.setAttr3("("+cfs2.getReportDate()+")");
			reportMap = financedata.getAllSubject(cfs2);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("301");
				if(rs!=null){
					extobjl1.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("302");
				if(rs!=null){
					extobjl2.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("304");
				if(rs!=null){
					extobjl3.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("303");
				if(rs!=null){
					extobjl4.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("305");
				if(rs!=null){
					extobjl5.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("308");
				if(rs!=null){
					extobjl6.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("310");
				if(rs!=null){
					extobjl7.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("312");
				if(rs!=null){
					extobjl8.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("314");
				if(rs!=null){
					extobjl9.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("309");
				if(rs!=null){
					extobjl10.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("311");
				if(rs!=null){
					extobjl11.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("307");
				if(rs!=null){
					extobjl12.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("321");
				if(rs!=null){
					extobjl13.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("317");
				if(rs!=null){
					extobjl14.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("316");
				if(rs!=null){
					extobjl15.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("323");
				if(rs!=null){
					extobjl16.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("325");
				if(rs!=null){
					extobjl17.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("324");
				if(rs!=null){
					extobjl18.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("329");
				if(rs!=null){
					extobjl19.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("331");
				if(rs!=null){
					extobjl20.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("328");
				if(rs!=null){
					extobjl21.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("330");
				if(rs!=null){
					extobjl22.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("332");
				if(rs!=null){
					extobjl23.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("333");
				if(rs!=null){
					extobjl24.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("341");
				if(rs!=null){
					extobjl25.setAttr3(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("343");
				if(rs!=null){
					extobjl26.setAttr3(rs.getCol2IntString());
				}
			}
		}
		
		CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年年末
		if(cfs3 != null ){
			if(!StringX.isSpace(cfs3.getReportDate()))extobjl0.setAttr4("("+cfs3.getReportDate()+")");
			reportMap = financedata.getAllSubject(cfs3);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("301");
				if(rs!=null){
					extobjl1.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("302");
				if(rs!=null){
					extobjl2.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("304");
				if(rs!=null){
					extobjl3.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("303");
				if(rs!=null){
					extobjl4.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("305");
				if(rs!=null){
					extobjl5.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("308");
				if(rs!=null){
					extobjl6.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("310");
				if(rs!=null){
					extobjl7.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("312");
				if(rs!=null){
					extobjl8.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("314");
				if(rs!=null){
					extobjl9.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("309");
				if(rs!=null){
					extobjl10.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("311");
				if(rs!=null){
					extobjl11.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("307");
				if(rs!=null){
					extobjl12.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("321");
				if(rs!=null){
					extobjl13.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("317");
				if(rs!=null){
					extobjl14.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("316");
				if(rs!=null){
					extobjl15.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("323");
				if(rs!=null){
					extobjl16.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("325");
				if(rs!=null){
					extobjl17.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("324");
				if(rs!=null){
					extobjl18.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("329");
				if(rs!=null){
					extobjl19.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("331");
				if(rs!=null){
					extobjl20.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("328");
				if(rs!=null){
					extobjl21.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("330");
				if(rs!=null){
					extobjl22.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("332");
				if(rs!=null){
					extobjl23.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("333");
				if(rs!=null){
					extobjl24.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("341");
				if(rs!=null){
					extobjl25.setAttr4(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("343");
				if(rs!=null){
					extobjl26.setAttr4(rs.getCol2IntString());
				}
			}
		}
		
		CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年年末
		if(cfs4 != null ){
			if(!StringX.isSpace(cfs4.getReportDate()))extobjl0.setAttr5("("+cfs4.getReportDate()+")");
			reportMap = financedata.getAllSubject(cfs4);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("301");
				if(rs!=null){
					extobjl1.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("302");
				if(rs!=null){
					extobjl2.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("304");
				if(rs!=null){
					extobjl3.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("303");
				if(rs!=null){
					extobjl4.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("305");
				if(rs!=null){
					extobjl5.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("308");
				if(rs!=null){
					extobjl6.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("310");
				if(rs!=null){
					extobjl7.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("312");
				if(rs!=null){
					extobjl8.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("314");
				if(rs!=null){
					extobjl9.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("309");
				if(rs!=null){
					extobjl10.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("311");
				if(rs!=null){
					extobjl11.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("307");
				if(rs!=null){
					extobjl12.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("321");
				if(rs!=null){
					extobjl13.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("317");
				if(rs!=null){
					extobjl14.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("316");
				if(rs!=null){
					extobjl15.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("323");
				if(rs!=null){
					extobjl16.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("325");
				if(rs!=null){
					extobjl17.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("324");
				if(rs!=null){
					extobjl18.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("329");
				if(rs!=null){
					extobjl19.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("331");
				if(rs!=null){
					extobjl20.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("328");
				if(rs!=null){
					extobjl21.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("330");
				if(rs!=null){
					extobjl22.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("332");
				if(rs!=null){
					extobjl23.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("333");
				if(rs!=null){
					extobjl24.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("341");
				if(rs!=null){
					extobjl25.setAttr5(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("343");
				if(rs!=null){
					extobjl26.setAttr5(rs.getCol2IntString());
				}
			}
		}
		}
	}
	
	public void getNew(){
		//新会计准则报表
		ReportSubject rs = null;
		String reportType = "";
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//本期
		//损益表
		if(cfs != null){
			reportType = cfs.getFinanceBelong();
			if(!StringX.isSpace(cfs.getReportDate()))extobjl0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAllSubject(cfs);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("301");//一、营业收入
				if(rs!=null){
					extobjl1.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("303");//减：营业成本
				if(rs!=null){
					extobjl2.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("305");//营业税金及附加
				if(rs!=null){
					extobjl3.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("307");
				if(rs!=null){
					extobjl4.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("309");
				if(rs!=null){
					extobjl5.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("311");//财务费用
				if(rs!=null){
					extobjl6.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("313");//资产减值损失
				if(rs!=null){
					extobjl7.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("315");//加：公允价值变动净收益
				if(rs!=null){
					extobjl8.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("317");//投资收益
				if(rs!=null){
					extobjl9.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("319");//其中：对联营企业和合营企业的投资收益
				if(rs!=null){
					extobjl10.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("321");//二、营业利润
				if(rs!=null){
					extobjl11.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("323");//加：营业外收入
				if(rs!=null){
					extobjl12.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("325");
				if(rs!=null){
					extobjl13.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("327");//其中：非流动资产处置净损失
				if(rs!=null){
					extobjl14.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("329");//三、利润总额
				if(rs!=null){
					extobjl15.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("331");//减：所得税费用
				if(rs!=null){
					extobjl16.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("333");//四、净利润
				if(rs!=null){
					extobjl17.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("396");//归属于母公司所有者的净利润
				if(rs!=null){
					extobjl18.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("328");
				if(rs!=null){
					extobjl19.setAttr1(rs.getCol2IntString());
				}
//		rs = (ReportSubject) reportMap.get("五、每股收益");
//		extobj20.setAttr1(rs.getCol2IntString());
				rs = (ReportSubject) reportMap.get("337");//(一)基本每股收益
				if(rs!=null){
					extobjl21.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("339");//(二)稀释每股收益
				if(rs!=null){
					extobjl22.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("341");
				if(rs!=null){
					extobjl23.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("343");
				if(rs!=null){
					extobjl24.setAttr1(rs.getCol2IntString());
				}
			}
			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
			if(cfs1 != null ){
				double d1;
				if(!StringX.isSpace(cfs1.getReportDate()))extobjl0.setAttr2("("+cfs1.getReportDate()+")");
				reportMap = financedata.getAllSubject(cfs1);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("301");
					if(rs!=null){
						extobjl1.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl1.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl1.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl1.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("303");
					if(rs!=null){
						extobjl2.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl2.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl2.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl2.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("305");
					if(rs!=null){
						extobjl3.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl3.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl3.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl3.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("307");
					if(rs!=null){
						extobjl4.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl4.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl4.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl4.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("309");
					if(rs!=null){
						extobjl5.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl5.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl5.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl5.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("311");
					if(rs!=null){
						extobjl6.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl6.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl6.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl6.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("313");
					if(rs!=null){
						extobjl7.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl7.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl7.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl7.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("315");
					if(rs!=null){
						extobjl8.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl8.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl8.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl8.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("317");
					if(rs!=null){
						extobjl9.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl9.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl9.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl9.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("319");
					if(rs!=null){
						extobjl10.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl10.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl10.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl10.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("321");
					if(rs!=null){
						extobjl11.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl11.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl11.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl11.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("323");
					if(rs!=null){
						extobjl12.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl12.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl12.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl12.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("325");
					if(rs!=null){
						extobjl13.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl13.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl13.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl13.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("327");//其中：非流动资产处置净损失
					if(rs!=null){
						extobjl14.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl14.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl14.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl14.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("329");
					if(rs!=null){
						extobjl15.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl15.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl15.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl15.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("331");
					if(rs!=null){
						extobjl16.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl16.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl16.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl16.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("333");//四、净利润
					if(rs!=null){
						extobjl17.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl17.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl17.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl17.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("396");
					if(rs!=null){
						extobjl18.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl18.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl18.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl18.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("328");
					if(rs!=null){
						extobjl19.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl19.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl19.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl19.setAttr6("");
						}
					}
//			rs = (ReportSubject) reportMap.get("五、每股收益");
//			extobj20.setAttr2(rs.getCol2IntString());
//				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
//					d1 = (Double.parseDouble(extobj20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
//					extobj20.setAttr6(String.format("%.0f",d1*100));
//				}else {
//					extobj20.setAttr6("");
//				}
					rs = (ReportSubject) reportMap.get("337");
					if(rs!=null){
						extobjl21.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl21.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl21.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl21.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("339");
					if(rs!=null){
						extobjl22.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl22.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl22.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl22.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("341");
					if(rs!=null){
						extobjl23.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl23.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl23.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl23.setAttr6("");
						}
					}
					rs = (ReportSubject) reportMap.get("343");
					if(rs!=null){
						extobjl24.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl24.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjl24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjl24.setAttr6(String.format("%.0f",d1*100));
						}else {
							extobjl24.setAttr6("");
						}
					}
				}
			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
			if(cfs2 != null ){
				if(!StringX.isSpace(cfs2.getReportDate()))extobjl0.setAttr3("("+cfs2.getReportDate()+")");
				reportMap = financedata.getAllSubject(cfs2);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("301");
					if(rs!=null){
						extobjl1.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("303");
					if(rs!=null){
						extobjl2.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("305");
					if(rs!=null){
						extobjl3.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("307");
					if(rs!=null){
						extobjl4.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("309");
					if(rs!=null){
						extobjl5.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("311");
					if(rs!=null){
						extobjl6.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("313");
					if(rs!=null){
						extobjl7.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("315");
					if(rs!=null){
						extobjl8.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("317");
					if(rs!=null){
						extobjl9.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("319");
					if(rs!=null){
						extobjl10.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("321");
					if(rs!=null){
						extobjl11.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("323");
					if(rs!=null){
						extobjl12.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("325");
					if(rs!=null){
						extobjl13.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("327");
					if(rs!=null){
						extobjl14.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("329");
					if(rs!=null){
						extobjl15.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("331");
					if(rs!=null){
						extobjl16.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("333");//四、净利润
					if(rs!=null){
						extobjl17.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("396");
					if(rs!=null){
						extobjl18.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("328");
					if(rs!=null){
						extobjl19.setAttr3(rs.getCol2IntString());
					}
//			rs = (ReportSubject) reportMap.get("五、每股收益");
//			extobj20.setAttr3(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("337");
					if(rs!=null){
						extobjl21.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("339");
					if(rs!=null){
						extobjl22.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("341");
					if(rs!=null){
						extobjl23.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("343");
					if(rs!=null){
						extobjl24.setAttr3(rs.getCol2IntString());
					}
				}
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年年末
			if(cfs3 != null ){
				if(!StringX.isSpace(cfs3.getReportDate()))extobjl0.setAttr4("("+cfs3.getReportDate()+")");
				reportMap = financedata.getAllSubject(cfs3);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("301");
					if(rs!=null){
						extobjl1.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("303");
					if(rs!=null){
						extobjl2.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("305");
					if(rs!=null){
						extobjl3.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("307");
					if(rs!=null){
						extobjl4.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("309");
					if(rs!=null){
						extobjl5.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("311");
					if(rs!=null){
						extobjl6.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("313");
					if(rs!=null){
						extobjl7.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("315");
					if(rs!=null){
						extobjl8.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("317");
					if(rs!=null){
						extobjl9.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("319");
					if(rs!=null){
						extobjl10.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("321");
					if(rs!=null){
						extobjl11.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("323");
					if(rs!=null){
						extobjl12.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("325");
					if(rs!=null){
						extobjl13.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("327");
					if(rs!=null){
						extobjl14.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("329");
					if(rs!=null){
						extobjl15.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("331");
					if(rs!=null){
						extobjl16.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("333");
					if(rs!=null){
						extobjl17.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("396");
					if(rs!=null){
						extobjl18.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("328");
					if(rs!=null){
						extobjl19.setAttr4(rs.getCol2IntString());
					}
//			rs = (ReportSubject) reportMap.get("五、每股收益");
//			extobj20.setAttr4(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("337");
					if(rs!=null){
						extobjl21.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("339");
					if(rs!=null){
						extobjl22.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("341");
					if(rs!=null){
						extobjl23.setAttr4(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("343");
					if(rs!=null){
						extobjl24.setAttr4(rs.getCol2IntString());
					}
				}
			}
			
			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年年末
			if(cfs4 != null ){
				if(!StringX.isSpace(cfs4.getReportDate()))extobjl0.setAttr5("("+cfs4.getReportDate()+")");
				reportMap = financedata.getAllSubject(cfs4);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("301");
					if(rs!=null){
						extobjl1.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("303");
					if(rs!=null){
						extobjl2.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("305");
					if(rs!=null){
						extobjl3.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("307");
					if(rs!=null){
						extobjl4.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("309");
					if(rs!=null){
						extobjl5.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("311");
					if(rs!=null){
						extobjl6.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("313");
					if(rs!=null){
						extobjl7.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("315");
					if(rs!=null){
						extobjl8.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("317");
					if(rs!=null){
						extobjl9.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("319");
					if(rs!=null){
						extobjl10.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("321");
					if(rs!=null){
						extobjl11.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("323");
					if(rs!=null){
						extobjl12.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("325");
					if(rs!=null){
						extobjl13.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("327");
					if(rs!=null){
						extobjl14.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("329");
					if(rs!=null){
						extobjl15.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("331");
					if(rs!=null){
						extobjl16.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("333");
					if(rs!=null){
						extobjl17.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("396");
					if(rs!=null){
						extobjl18.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("328");
					if(rs!=null){
						extobjl19.setAttr5(rs.getCol2IntString());
					}
//			rs = (ReportSubject) reportMap.get("五、每股收益");
//			extobj20.setAttr5(rs.getCol2IntString());
					rs = (ReportSubject) reportMap.get("337");
					if(rs!=null){
						extobjl21.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("339");
					if(rs!=null){
						extobjl22.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("341");
					if(rs!=null){
						extobjl23.setAttr5(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("343");
					if(rs!=null){
						extobjl24.setAttr5(rs.getCol2IntString());
					}
				}
			}
		}
		
	
	}

	public void getAssure(){
		//担保公司报表
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//本期
		if(cfs != null){
			String reportType = cfs.getFinanceBelong();
			if(!StringX.isSpace(cfs.getReportDate()))extobjl0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getLossMap(cfs);
			rs = (ReportSubject) reportMap.get("一、担保业务收入");
			extobjl1.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("其中：1、担保费收入");
			extobjl2.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("2、手续费收入");
			extobjl3.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("3、评审费收入");
			extobjl4.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("4、追偿收入");
			extobjl5.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("5、其他收入");
			extobjl6.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("二、担保业务成本");
			extobjl7.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("其中：1、担保赔偿支出");
			extobjl8.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("2、分担保费支出");
			extobjl9.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("3、手续费支出");
			extobjl10.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("4、营业税金及附加");
			extobjl11.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("5、其他支出");
			extobjl12.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("三、担保业务利润");
			extobjl13.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("加：利息净收入(净支出以“-”号填列)");
			extobjl14.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("加：其他业务利润");
			extobjl15.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("减：营业费用");
			extobjl16.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("加：投资收益(投资损失以“-”号填列)");
			extobjl17.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("四、营业利润");
			extobjl18.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("加：营业外收入(净亏损以“-”号填列)");
			extobjl19.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("五、扣除资产减值损失前利润总额(亏损以“-”号填列)");
			extobjl20.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("减：资产减值损失(转回的金额以“-”号填列)");
			extobjl21.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("六、扣除资产减值损失后的利润总额(亏损总额以“-”号填列)");
			extobjl22.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("减：所得税");
			extobjl23.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("七、净利润(净亏损以“-”号填列)");
			extobjl24.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("加：年初未分配利润");
			extobjl25.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("一般风险准备转入");
			extobjl26.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("其他转入");
			extobjl27.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("八、可供分配的利润");
			extobjl28.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("减：提取一般风险准备");
			extobjl29.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("提取法定盈余公积");
			extobjl30.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("九、可供投资者分配的利润");
			extobjl31.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("减：应付优先股股利");
			extobjl32.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("提取任意盈余公积");
			extobjl33.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("应付普通股股利");
			extobjl34.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("转作资本(或股本)的普通股股利");
			extobjl35.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("十、未分配的利润");
			extobjl36.setAttr1(rs.getCol2ValueString());
			
			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
			if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs1.getReportDate()))extobjl0.setAttr2("("+cfs1.getReportDate()+")");
				double d1;
				reportMap = financedata.getLossMap(cfs1);
				rs = (ReportSubject) reportMap.get("一、担保业务收入");
				extobjl1.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl1.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl1.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl1.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其中：1、担保费收入");
				extobjl2.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl2.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl2.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl2.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("2、手续费收入");
				extobjl3.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl3.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl3.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl3.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("3、评审费收入");
				extobjl4.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl4.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl4.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl4.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("4、追偿收入");
				extobjl5.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl5.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl5.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl5.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("5、其他收入");
				extobjl6.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl6.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl6.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl6.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("二、担保业务成本");
				extobjl7.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl7.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl7.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl7.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其中：1、担保赔偿支出");
				extobjl8.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl8.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl8.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl8.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("2、分担保费支出");
				extobjl9.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl9.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl9.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl9.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("3、手续费支出");
				extobjl10.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl10.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl10.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl10.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("4、营业税金及附加");
				extobjl11.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl11.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl11.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl11.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("5、其他支出");
				extobjl12.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl12.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl12.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl12.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("三、担保业务利润");
				extobjl13.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl13.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl13.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl13.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：利息净收入(净支出以“-”号填列)");
				extobjl14.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl14.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl14.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl14.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("310");
				extobjl15.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl15.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl15.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl15.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：营业费用");
				extobjl16.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl16.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl16.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl16.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：投资收益(投资损失以“-”号填列)");
				extobjl17.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl17.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl17.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl17.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("321");
				extobjl18.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl18.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl18.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl18.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：营业外收入(净亏损以“-”号填列)");
				extobjl19.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl19.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl19.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl19.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("五、扣除资产减值损失前利润总额(亏损以“-”号填列)");
				extobjl20.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl20.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl20.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl20.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：资产减值损失(转回的金额以“-”号填列)");
				extobjl21.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl21.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl21.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl21.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("六、扣除资产减值损失后的利润总额(亏损总额以“-”号填列)");
				extobjl22.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl22.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl22.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl22.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("331");
				extobjl23.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl23.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl23.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl23.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("七、净利润(净亏损以“-”号填列)");
				extobjl24.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl24.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl24.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl24.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("加：年初未分配利润");
				extobjl25.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl25.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl25.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl25.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("一般风险准备转入");
				extobjl26.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl26.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl26.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl26.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl26.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其他转入");
				extobjl27.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl27.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl27.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl27.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl27.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("八、可供分配的利润");
				extobjl28.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl28.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl28.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl28.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl28.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：提取一般风险准备");
				extobjl29.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl29.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl29.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl29.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl29.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("提取法定盈余公积");
				extobjl30.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl30.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl30.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl30.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl30.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("九、可供投资者分配的利润");
				extobjl31.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl31.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl31.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl31.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl31.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("减：应付优先股股利");
				extobjl32.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl32.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl32.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl32.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl32.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("提取任意盈余公积");
				extobjl33.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl33.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl33.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl33.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl33.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("343");
				extobjl34.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl34.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl34.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl34.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl34.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("转作资本(或股本)的普通股股利");
				extobjl35.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl35.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl35.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl35.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl35.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("十、未分配的利润");
				extobjl36.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjl36.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjl36.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjl36.setAttr6(String.format("%.2f",d1));
				}else {
					extobjl36.setAttr6("");
				}
			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
			if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs2.getReportDate()))extobjl0.setAttr3("("+cfs2.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs2);
				rs = (ReportSubject) reportMap.get("一、担保业务收入");
				extobjl1.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其中：1、担保费收入");
				extobjl2.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("2、手续费收入");
				extobjl3.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("3、评审费收入");
				extobjl4.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("4、追偿收入");
				extobjl5.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("5、其他收入");
				extobjl6.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("二、担保业务成本");
				extobjl7.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其中：1、担保赔偿支出");
				extobjl8.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("2、分担保费支出");
				extobjl9.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("3、手续费支出");
				extobjl10.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("4、营业税金及附加");
				extobjl11.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("5、其他支出");
				extobjl12.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("三、担保业务利润");
				extobjl13.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：利息净收入(净支出以“-”号填列)");
				extobjl14.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：其他业务利润");
				extobjl15.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：营业费用");
				extobjl16.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：投资收益(投资损失以“-”号填列)");
				extobjl17.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("四、营业利润");
				extobjl18.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：营业外收入(净亏损以“-”号填列)");
				extobjl19.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("五、扣除资产减值损失前利润总额(亏损以“-”号填列)");
				extobjl20.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：资产减值损失(转回的金额以“-”号填列)");
				extobjl21.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("六、扣除资产减值损失后的利润总额(亏损总额以“-”号填列)");
				extobjl22.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：所得税");
				extobjl23.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("七、净利润(净亏损以“-”号填列)");
				extobjl24.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：年初未分配利润");
				extobjl25.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("一般风险准备转入");
				extobjl26.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其他转入");
				extobjl27.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("八、可供分配的利润");
				extobjl28.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：提取一般风险准备");
				extobjl29.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("提取法定盈余公积");
				extobjl30.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("九、可供投资者分配的利润");
				extobjl31.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：应付优先股股利");
				extobjl32.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("提取任意盈余公积");
				extobjl33.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl34.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("转作资本(或股本)的普通股股利");
				extobjl35.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("十、未分配的利润");
				extobjl36.setAttr3(rs.getCol2ValueString());
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年年末
			if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs3.getReportDate()))extobjl0.setAttr4("("+cfs3.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs3);
				rs = (ReportSubject) reportMap.get("一、担保业务收入");
				extobjl1.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其中：1、担保费收入");
				extobjl2.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("2、手续费收入");
				extobjl3.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("3、评审费收入");
				extobjl4.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("4、追偿收入");
				extobjl5.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("5、其他收入");
				extobjl6.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("二、担保业务成本");
				extobjl7.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其中：1、担保赔偿支出");
				extobjl8.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("2、分担保费支出");
				extobjl9.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("3、手续费支出");
				extobjl10.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("4、营业税金及附加");
				extobjl11.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("5、其他支出");
				extobjl12.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("三、担保业务利润");
				extobjl13.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：利息净收入(净支出以“-”号填列)");
				extobjl14.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：其他业务利润");
				extobjl15.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：营业费用");
				extobjl16.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：投资收益(投资损失以“-”号填列)");
				extobjl17.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("四、营业利润");
				extobjl18.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：营业外收入(净亏损以“-”号填列)");
				extobjl19.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("五、扣除资产减值损失前利润总额(亏损以“-”号填列)");
				extobjl20.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：资产减值损失(转回的金额以“-”号填列)");
				extobjl21.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("六、扣除资产减值损失后的利润总额(亏损总额以“-”号填列)");
				extobjl22.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：所得税");
				extobjl23.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("七、净利润(净亏损以“-”号填列)");
				extobjl24.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：年初未分配利润");
				extobjl25.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("一般风险准备转入");
				extobjl26.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其他转入");
				extobjl27.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("八、可供分配的利润");
				extobjl28.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：提取一般风险准备");
				extobjl29.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("提取法定盈余公积");
				extobjl30.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("九、可供投资者分配的利润");
				extobjl31.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：应付优先股股利");
				extobjl32.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("提取任意盈余公积");
				extobjl33.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl34.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("转作资本(或股本)的普通股股利");
				extobjl35.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("十、未分配的利润");
				extobjl36.setAttr4(rs.getCol2ValueString());
			}
			
			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年年末
			if(cfs4 != null && cfs4.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs4.getReportDate()))extobjl0.setAttr5("("+cfs4.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs4);
				rs = (ReportSubject) reportMap.get("一、担保业务收入");
				extobjl1.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其中：1、担保费收入");
				extobjl2.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("2、手续费收入");
				extobjl3.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("3、评审费收入");
				extobjl4.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("4、追偿收入");
				extobjl5.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("5、其他收入");
				extobjl6.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("二、担保业务成本");
				extobjl7.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其中：1、担保赔偿支出");
				extobjl8.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("2、分担保费支出");
				extobjl9.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("3、手续费支出");
				extobjl10.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("4、营业税金及附加");
				extobjl11.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("5、其他支出");
				extobjl12.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("三、担保业务利润");
				extobjl13.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：利息净收入(净支出以“-”号填列)");
				extobjl14.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：其他业务利润");
				extobjl15.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：营业费用");
				extobjl16.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：投资收益(投资损失以“-”号填列)");
				extobjl17.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("四、营业利润");
				extobjl18.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：营业外收入(净亏损以“-”号填列)");
				extobjl19.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("五、扣除资产减值损失前利润总额(亏损以“-”号填列)");
				extobjl20.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：资产减值损失(转回的金额以“-”号填列)");
				extobjl21.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("六、扣除资产减值损失后的利润总额(亏损总额以“-”号填列)");
				extobjl22.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：所得税");
				extobjl23.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("七、净利润(净亏损以“-”号填列)");
				extobjl24.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("加：年初未分配利润");
				extobjl25.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("一般风险准备转入");
				extobjl26.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其他转入");
				extobjl27.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("八、可供分配的利润");
				extobjl28.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：提取一般风险准备");
				extobjl29.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("提取法定盈余公积");
				extobjl30.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("九、可供投资者分配的利润");
				extobjl31.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("减：应付优先股股利");
				extobjl32.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("提取任意盈余公积");
				extobjl33.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("应付普通股股利");
				extobjl34.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("转作资本(或股本)的普通股股利");
				extobjl35.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("十、未分配的利润");
				extobjl36.setAttr5(rs.getCol2ValueString());
			}
		}
	}
	
	public DocExtClass getExtobjl0() {
		return extobjl0;
	}
	public void getOE(){
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewestReport(customerID);//本期
		String reportType = cfs.getFinanceBelong();
		if(cfs != null){
			if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getLossMap(cfs);
			rs = (ReportSubject) reportMap.get("财政补助收入");
			extobj1.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("上级补助收入");
			extobj2.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("附属单位缴款(上缴收入)");
			extobj3.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("事业收入");
			extobj4.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("其中：预算外资金收入");
			extobj5.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("其他收入");
			extobj6.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("经营收入");
			extobj7.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("拨入专款");
			extobj8.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("收入合计");
			extobj9.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("拨出经费");
			extobj10.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("上缴上级支出");
			extobj11.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("对附属单位补助");
			extobj12.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("事业支出");
			extobj13.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("销售税金");
			extobj14.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("结转自筹基建");
			extobj15.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("经营支出");
			extobj16.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("成本费用");
			extobj17.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("拨出专款");
			extobj18.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("专款支出");
			extobj19.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("其他支出");
			extobj20.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("支出合计");
			extobj21.setAttr1(rs.getCol2ValueString());
			rs = (ReportSubject) reportMap.get("收支结余");
			extobj22.setAttr1(rs.getCol2ValueString());
			
			CustomerFSRecord cfs1 = financedata.getLastSerNReport(cfs, -1);//获得去年同期
			if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)){
				double d1;
				if(!StringX.isSpace(cfs1.getReportDate()))extobj0.setAttr2("("+cfs1.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs1);
				rs = (ReportSubject) reportMap.get("财政补助收入");
				extobj1.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj1.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj1.setAttr6(String.format("%.2f",d1));
				}else {
					extobj1.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj2.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj2.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj2.setAttr6(String.format("%.2f",d1));
				}else {
					extobj2.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("附属单位缴款(上缴收入)");
				extobj3.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj3.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj3.setAttr6(String.format("%.2f",d1));
				}else {
					extobj3.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("事业收入");
				extobj4.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj4.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj4.setAttr6(String.format("%.2f",d1));
				}else {
					extobj4.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其中：预算外资金收入");
				extobj5.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj5.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj5.setAttr6(String.format("%.2f",d1));
				}else {
					extobj5.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj6.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj6.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj6.setAttr6(String.format("%.2f",d1));
				}else {
					extobj6.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("经营收入");
				extobj7.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj7.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj7.setAttr6(String.format("%.2f",d1));
				}else {
					extobj7.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj8.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj8.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj8.setAttr6(String.format("%.2f",d1));
				}else {
					extobj8.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj9.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj9.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj9.setAttr6(String.format("%.2f",d1));
				}else {
					extobj9.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("拨出经费");
				extobj10.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj10.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj10.setAttr6(String.format("%.2f",d1));
				}else {
					extobj10.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("上缴上级支出");
				extobj11.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj11.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj11.setAttr6(String.format("%.2f",d1));
				}else {
					extobj11.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj12.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj12.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj12.setAttr6(String.format("%.2f",d1));
				}else {
					extobj12.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("事业支出");
				extobj13.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj13.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj13.setAttr6(String.format("%.2f",d1));
				}else {
					extobj13.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("销售税金");
				extobj14.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj14.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj14.setAttr6(String.format("%.2f",d1));
				}else {
					extobj14.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("结转自筹基建");
				extobj15.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj15.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj15.setAttr6(String.format("%.2f",d1));
				}else {
					extobj15.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("经营支出");
				extobj16.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj16.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj16.setAttr6(String.format("%.2f",d1));
				}else {
					extobj16.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("成本费用");
				extobj17.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj17.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj17.setAttr6(String.format("%.2f",d1));
				}else {
					extobj17.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("拨出专款");
				extobj18.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj18.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj18.setAttr6(String.format("%.2f",d1));
				}else {
					extobj18.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("专款支出");
				extobj19.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj19.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj19.setAttr6(String.format("%.2f",d1));
				}else {
					extobj19.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("其他支出");
				extobj20.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj20.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj20.setAttr6(String.format("%.2f",d1));
				}else {
					extobj20.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj21.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj21.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj21.setAttr6(String.format("%.2f",d1));
				}else {
					extobj21.setAttr6("");
				}
				rs = (ReportSubject) reportMap.get("收支结余");
				extobj22.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobj22.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobj22.setAttr6(String.format("%.2f",d1));
				}else {
					extobj22.setAttr6("");
				}
			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//获得去年年末
			if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr3("("+cfs2.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs2);
				rs = (ReportSubject) reportMap.get("财政补助收入");
				extobj1.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj2.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("附属单位缴款(上缴收入)");
				extobj3.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("事业收入");
				extobj4.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其中：预算外资金收入");
				extobj5.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj6.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("经营收入");
				extobj7.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj8.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj9.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("拨出经费");
				extobj10.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("上缴上级支出");
				extobj11.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj12.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("事业支出");
				extobj13.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("销售税金");
				extobj14.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("结转自筹基建");
				extobj15.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("经营支出");
				extobj16.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("成本费用");
				extobj17.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("拨出专款");
				extobj18.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("专款支出");
				extobj19.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其他支出");
				extobj20.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj21.setAttr3(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收支结余");
				extobj22.setAttr3(rs.getCol2ValueString());
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//获得上两年年末
			if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr4("("+cfs3.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs3);
				rs = (ReportSubject) reportMap.get("财政补助收入");
				extobj1.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj2.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("附属单位缴款(上缴收入)");
				extobj3.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("事业收入");
				extobj4.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其中：预算外资金收入");
				extobj5.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj6.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("经营收入");
				extobj7.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj8.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj9.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("拨出经费");
				extobj10.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("上缴上级支出");
				extobj11.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj12.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("事业支出");
				extobj13.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("销售税金");
				extobj14.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("结转自筹基建");
				extobj15.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("经营支出");
				extobj16.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("成本费用");
				extobj17.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("拨出专款");
				extobj18.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("专款支出");
				extobj19.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其他支出");
				extobj20.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj21.setAttr4(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收支结余");
				extobj22.setAttr4(rs.getCol2ValueString());
			}
			
			CustomerFSRecord cfs4 = financedata.getRelativeYearReport(cfs, -3);//获得上三年年末
			if(cfs4 != null && cfs4.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs4.getReportDate()))extobj0.setAttr5("("+cfs4.getReportDate()+")");
				reportMap = financedata.getLossMap(cfs4);
				rs = (ReportSubject) reportMap.get("财政补助收入");
				extobj1.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("上级补助收入");
				extobj2.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("附属单位缴款(上缴收入)");
				extobj3.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("事业收入");
				extobj4.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其中：预算外资金收入");
				extobj5.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其他收入");
				extobj6.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("经营收入");
				extobj7.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("拨入专款");
				extobj8.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收入合计");
				extobj9.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("拨出经费");
				extobj10.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("上缴上级支出");
				extobj11.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("对附属单位补助");
				extobj12.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("事业支出");
				extobj13.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("销售税金");
				extobj14.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("结转自筹基建");
				extobj15.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("经营支出");
				extobj16.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("成本费用");
				extobj17.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("拨出专款");
				extobj18.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("专款支出");
				extobj19.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("其他支出");
				extobj20.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("支出合计");
				extobj21.setAttr5(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收支结余");
				extobj22.setAttr5(rs.getCol2ValueString());
			}
		}
	}
	
	public void setExtobjl0(DocExtClass extobjl0) {
		this.extobjl0 = extobjl0;
	}

	public DocExtClass getExtobjl1() {
		return extobjl1;
	}

	public void setExtobjl1(DocExtClass extobjl1) {
		this.extobjl1 = extobjl1;
	}

	public DocExtClass getExtobjl2() {
		return extobjl2;
	}

	public void setExtobjl2(DocExtClass extobjl2) {
		this.extobjl2 = extobjl2;
	}

	public DocExtClass getExtobjl3() {
		return extobjl3;
	}

	public void setExtobjl3(DocExtClass extobjl3) {
		this.extobjl3 = extobjl3;
	}

	public DocExtClass getExtobjl4() {
		return extobjl4;
	}

	public void setExtobjl4(DocExtClass extobjl4) {
		this.extobjl4 = extobjl4;
	}

	public DocExtClass getExtobjl5() {
		return extobjl5;
	}

	public void setExtobjl5(DocExtClass extobjl5) {
		this.extobjl5 = extobjl5;
	}

	public DocExtClass getExtobjl6() {
		return extobjl6;
	}

	public void setExtobjl6(DocExtClass extobjl6) {
		this.extobjl6 = extobjl6;
	}

	public DocExtClass getExtobjl7() {
		return extobjl7;
	}

	public void setExtobjl7(DocExtClass extobjl7) {
		this.extobjl7 = extobjl7;
	}

	public DocExtClass getExtobjl8() {
		return extobjl8;
	}

	public void setExtobjl8(DocExtClass extobjl8) {
		this.extobjl8 = extobjl8;
	}

	public DocExtClass getExtobjl9() {
		return extobjl9;
	}

	public void setExtobjl9(DocExtClass extobjl9) {
		this.extobjl9 = extobjl9;
	}

	public DocExtClass getExtobjl10() {
		return extobjl10;
	}

	public void setExtobjl10(DocExtClass extobjl10) {
		this.extobjl10 = extobjl10;
	}

	public DocExtClass getExtobjl11() {
		return extobjl11;
	}

	public void setExtobjl11(DocExtClass extobjl11) {
		this.extobjl11 = extobjl11;
	}

	public DocExtClass getExtobjl12() {
		return extobjl12;
	}

	public void setExtobjl12(DocExtClass extobjl12) {
		this.extobjl12 = extobjl12;
	}

	public DocExtClass getExtobjl13() {
		return extobjl13;
	}

	public void setExtobjl13(DocExtClass extobjl13) {
		this.extobjl13 = extobjl13;
	}

	public DocExtClass getExtobjl14() {
		return extobjl14;
	}

	public void setExtobjl14(DocExtClass extobjl14) {
		this.extobjl14 = extobjl14;
	}

	public DocExtClass getExtobjl15() {
		return extobjl15;
	}

	public void setExtobjl15(DocExtClass extobjl15) {
		this.extobjl15 = extobjl15;
	}

	public DocExtClass getExtobjl16() {
		return extobjl16;
	}

	public void setExtobjl16(DocExtClass extobjl16) {
		this.extobjl16 = extobjl16;
	}

	public DocExtClass getExtobjl17() {
		return extobjl17;
	}

	public void setExtobjl17(DocExtClass extobjl17) {
		this.extobjl17 = extobjl17;
	}

	public DocExtClass getExtobjl18() {
		return extobjl18;
	}

	public void setExtobjl18(DocExtClass extobjl18) {
		this.extobjl18 = extobjl18;
	}

	public DocExtClass getExtobjl19() {
		return extobjl19;
	}

	public void setExtobjl19(DocExtClass extobjl19) {
		this.extobjl19 = extobjl19;
	}

	public DocExtClass getExtobjl20() {
		return extobjl20;
	}

	public void setExtobjl20(DocExtClass extobjl20) {
		this.extobjl20 = extobjl20;
	}

	public DocExtClass getExtobjl21() {
		return extobjl21;
	}

	public void setExtobjl21(DocExtClass extobjl21) {
		this.extobjl21 = extobjl21;
	}

	public DocExtClass getExtobjl22() {
		return extobjl22;
	}

	public void setExtobjl22(DocExtClass extobjl22) {
		this.extobjl22 = extobjl22;
	}

	public DocExtClass getExtobjl23() {
		return extobjl23;
	}

	public void setExtobjl23(DocExtClass extobjl23) {
		this.extobjl23 = extobjl23;
	}

	public DocExtClass getExtobjl24() {
		return extobjl24;
	}

	public void setExtobjl24(DocExtClass extobjl24) {
		this.extobjl24 = extobjl24;
	}

	public DocExtClass getExtobjl25() {
		return extobjl25;
	}

	public void setExtobjl25(DocExtClass extobjl25) {
		this.extobjl25 = extobjl25;
	}

	public DocExtClass getExtobjl26() {
		return extobjl26;
	}

	public void setExtobjl26(DocExtClass extobjl26) {
		this.extobjl26 = extobjl26;
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
	public DocExtClass getExtobjl27() {
		return extobjl27;
	}

	public void setExtobjl27(DocExtClass extobjl27) {
		this.extobjl27 = extobjl27;
	}

	public DocExtClass getExtobjl28() {
		return extobjl28;
	}

	public void setExtobjl28(DocExtClass extobjl28) {
		this.extobjl28 = extobjl28;
	}

	public DocExtClass getExtobjl29() {
		return extobjl29;
	}

	public void setExtobjl29(DocExtClass extobjl29) {
		this.extobjl29 = extobjl29;
	}

	public DocExtClass getExtobjl30() {
		return extobjl30;
	}

	public void setExtobjl30(DocExtClass extobjl30) {
		this.extobjl30 = extobjl30;
	}

	public DocExtClass getExtobjl31() {
		return extobjl31;
	}

	public void setExtobjl31(DocExtClass extobjl31) {
		this.extobjl31 = extobjl31;
	}

	public DocExtClass getExtobjl32() {
		return extobjl32;
	}

	public void setExtobjl32(DocExtClass extobjl32) {
		this.extobjl32 = extobjl32;
	}

	public DocExtClass getExtobjl33() {
		return extobjl33;
	}

	public void setExtobjl33(DocExtClass extobjl33) {
		this.extobjl33 = extobjl33;
	}

	public DocExtClass getExtobjl34() {
		return extobjl34;
	}

	public void setExtobjl34(DocExtClass extobjl34) {
		this.extobjl34 = extobjl34;
	}

	public DocExtClass getExtobjl35() {
		return extobjl35;
	}

	public void setExtobjl35(DocExtClass extobjl35) {
		this.extobjl35 = extobjl35;
	}

	public DocExtClass getExtobjl36() {
		return extobjl36;
	}

	public void setExtobjl36(DocExtClass extobjl36) {
		this.extobjl36 = extobjl36;
	}

	public String getOpinion() {
		return opinion;
	}

	public void setOpinion(String opinion) {
		this.opinion = opinion;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
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

	public DocExtClass getExtobj15() {
		return extobj15;
	}

	public void setExtobj15(DocExtClass extobj15) {
		this.extobj15 = extobj15;
	}

	public DocExtClass getExtobj16() {
		return extobj16;
	}

	public void setExtobj16(DocExtClass extobj16) {
		this.extobj16 = extobj16;
	}

	public DocExtClass getExtobj17() {
		return extobj17;
	}

	public void setExtobj17(DocExtClass extobj17) {
		this.extobj17 = extobj17;
	}

	public DocExtClass getExtobj18() {
		return extobj18;
	}

	public void setExtobj18(DocExtClass extobj18) {
		this.extobj18 = extobj18;
	}

	public DocExtClass getExtobj19() {
		return extobj19;
	}

	public void setExtobj19(DocExtClass extobj19) {
		this.extobj19 = extobj19;
	}

	public DocExtClass getExtobj20() {
		return extobj20;
	}

	public void setExtobj20(DocExtClass extobj20) {
		this.extobj20 = extobj20;
	}

	public DocExtClass getExtobj21() {
		return extobj21;
	}

	public void setExtobj21(DocExtClass extobj21) {
		this.extobj21 = extobj21;
	}

	public DocExtClass getExtobj22() {
		return extobj22;
	}

	public void setExtobj22(DocExtClass extobj22) {
		this.extobj22 = extobj22;
	}
	
	//医疗类
	public DocExtClass getext1() {
		return ext1;
	}

	public void setext1(DocExtClass ext1) {
		this.ext1 = ext1;
	}

	public DocExtClass getext2() {
		return ext2;
	}

	public void setext2(DocExtClass ext2) {
		this.ext2 = ext2;
	}

	public DocExtClass getext3() {
		return ext3;
	}

	public void setext3(DocExtClass ext3) {
		this.ext3 = ext3;
	}

	public DocExtClass getext4() {
		return ext4;
	}

	public void setext4(DocExtClass ext4) {
		this.ext4 = ext4;
	}

	public DocExtClass getext5() {
		return ext5;
	}

	public void setext5(DocExtClass ext5) {
		this.ext5 = ext5;
	}

	public DocExtClass getext6() {
		return ext6;
	}

	public void setext6(DocExtClass ext6) {
		this.ext6 = ext6;
	}

	public DocExtClass getext7() {
		return ext7;
	}

	public void setext7(DocExtClass ext7) {
		this.ext7 = ext7;
	}

	public DocExtClass getext8() {
		return ext8;
	}

	public void setext8(DocExtClass ext8) {
		this.ext8 = ext8;
	}

	public DocExtClass getext9() {
		return ext9;
	}

	public void setext9(DocExtClass ext9) {
		this.ext9 = ext9;
	}

	public DocExtClass getext10() {
		return ext10;
	}

	public void setext10(DocExtClass ext10) {
		this.ext10 = ext10;
	}

	public DocExtClass getext11() {
		return ext11;
	}

	public void setext11(DocExtClass ext11) {
		this.ext11 = ext11;
	}

	public DocExtClass getext12() {
		return ext12;
	}

	public void setext12(DocExtClass ext12) {
		this.ext12 = ext12;
	}

	public DocExtClass getext13() {
		return ext13;
	}

	public void setext13(DocExtClass ext13) {
		this.ext13 = ext13;
	}

	public DocExtClass getext14() {
		return ext14;
	}

	public void setext14(DocExtClass ext14) {
		this.ext14 = ext14;
	}

	public DocExtClass getext15() {
		return ext15;
	}

	public void setext15(DocExtClass ext15) {
		this.ext15 = ext15;
	}

	public DocExtClass getext16() {
		return ext16;
	}

	public void setext16(DocExtClass ext16) {
		this.ext16 = ext16;
	}

	public DocExtClass getext17() {
		return ext17;
	}

	public void setext17(DocExtClass ext17) {
		this.ext17 = ext17;
	}

	public DocExtClass getext18() {
		return ext18;
	}

	public void setext18(DocExtClass ext18) {
		this.ext18 = ext18;
	}

	public DocExtClass getext19() {
		return ext19;
	}

	public void setext19(DocExtClass ext19) {
		this.ext19 = ext19;
	}

	public DocExtClass getext20() {
		return ext20;
	}

	public void setext20(DocExtClass ext20) {
		this.ext20 = ext20;
	}

	public DocExtClass getext21() {
		return ext21;
	}

	public void setext21(DocExtClass ext21) {
		this.ext21 = ext21;
	}

	public DocExtClass getext22() {
		return ext22;
	}

	public void setext22(DocExtClass ext22) {
		this.ext22 = ext22;
	}

	public DocExtClass getext23() {
		return ext23;
	}

	public void setext23(DocExtClass ext23) {
		this.ext23 = ext23;
	}

	public DocExtClass getext24() {
		return ext24;
	}

	public void setext24(DocExtClass ext24) {
		this.ext24 = ext24;
	}

	public DocExtClass getext25() {
		return ext25;
	}

	public void setext25(DocExtClass ext25) {
		this.ext25 = ext25;
	}

	public DocExtClass getext0() {
		return ext0;
	}

	public void setext0(DocExtClass ext0) {
		this.ext0 = ext0;
	}
	
	public DocExtClass getExtobj23() {
		return extobj23;
	}

	public void setExtobj23(DocExtClass extobj23) {
		this.extobj23 = extobj23;
	}

	public DocExtClass getExtobj24() {
		return extobj24;
	}

	public void setExtobj24(DocExtClass extobj24) {
		this.extobj24 = extobj24;
	}

	public DocExtClass getExtobj25() {
		return extobj25;
	}

	public void setExtobj25(DocExtClass extobj25) {
		this.extobj25 = extobj25;
	}
	
}

