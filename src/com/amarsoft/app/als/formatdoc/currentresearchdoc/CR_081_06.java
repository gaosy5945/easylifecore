package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.FileInputStream;
import java.io.Serializable;
import java.util.Map;

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

public class CR_081_06 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;
	//现金流量表
    private DocExtClass extobjx0;
    private DocExtClass extobjx1;
    private DocExtClass extobjx2;
    private DocExtClass extobjx3;
    private DocExtClass extobjx4;
    private DocExtClass extobjx5;
    private DocExtClass extobjx6;
    private DocExtClass extobjx7;
    private DocExtClass extobjx8;
    private DocExtClass extobjx9;
    private DocExtClass extobjx10;
    private DocExtClass extobjx11;
    private DocExtClass extobjx12;
    private DocExtClass extobjx13;
    private DocExtClass extobjx14;
    private DocExtClass extobjx15;
    private DocExtClass extobjx16;
    private DocExtClass extobjx17;
    private DocExtClass extobjx18;
    private DocExtClass extobjx19;
    private DocExtClass extobjx20;
    private DocExtClass extobjx21;
    private DocExtClass extobjx22;
    private DocExtClass extobjx23;
    private DocExtClass extobjx24;
    private DocExtClass extobjx25;
    private DocExtClass extobjx26;
    private DocExtClass extobjx27;
    private DocExtClass extobjx28;
    private DocExtClass extobjx29;
    private DocExtClass extobjx30;
    private DocExtClass extobjx31;
    private DocExtClass extobjx32;
    private DocExtClass extobjx33;
    private DocExtClass extobjx34;
    private DocExtClass extobjx35;
    
    private String opinion1 = "";
    private String sFinancelType="";
	BizObjectManager m = null;
	BizObjectQuery q = null;
	BizObject bo = null;
	String customerID = "";
	public CR_081_06() {
	}

	public boolean initObjectForRead() {
		extobjx0 = new DocExtClass();
		extobjx1 = new DocExtClass();
		extobjx2 = new DocExtClass();
		extobjx3 = new DocExtClass();
		extobjx4 = new DocExtClass();
		extobjx5 = new DocExtClass();
		extobjx6 = new DocExtClass();
		extobjx7 = new DocExtClass();
		extobjx8 = new DocExtClass();
		extobjx9 = new DocExtClass();
		extobjx10 = new DocExtClass();
		extobjx11 = new DocExtClass();
		extobjx12 = new DocExtClass();
		extobjx13 = new DocExtClass();
		extobjx14 = new DocExtClass();
		extobjx15 = new DocExtClass();
		extobjx16 = new DocExtClass();
		extobjx17 = new DocExtClass();
		extobjx18 = new DocExtClass();
		extobjx19 = new DocExtClass();
		extobjx20 = new DocExtClass();
		extobjx21 = new DocExtClass();
		extobjx22 = new DocExtClass();
		extobjx23 = new DocExtClass();
		extobjx24 = new DocExtClass();
		extobjx25 = new DocExtClass();
		extobjx26 = new DocExtClass();
		extobjx27 = new DocExtClass();
		extobjx28 = new DocExtClass();
		extobjx29 = new DocExtClass();
		extobjx30 = new DocExtClass();
		extobjx31 = new DocExtClass();
		extobjx32 = new DocExtClass();
		extobjx33 = new DocExtClass();
		extobjx34 = new DocExtClass();
		extobjx35 = new DocExtClass();
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
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	public boolean initObjectForEdit() {
		opinion1 =  " ";
		return true;
	}
	
	public void setModelInputStream()throws Exception{
		//String sFinancelType = "010";//以新会计准则为例
		try{
			if(sFinancelType.equals("010")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_new_06.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_new_06.html");//templateFileName+"_new.html"文件要存在
			}else if(sFinancelType.equals("020")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_06.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_06.html");//templateFileName+"_old.html"文件要存在
			}else if(sFinancelType.equals("160")){
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_assure_06.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_assure_06.html");
			}else{
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/Blank_000.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/Blank_000.html");
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
	
	public void getOld(){
		//旧会计准则报表
		ReportSubject rs = null;
		String reportType = "";
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord c = financedata.getNewestReport(customerID);
		CustomerFSRecord cfs = financedata.getNewYearReport(customerID);//最新一期年报
		if(cfs != null){
		//现金流量表
			reportType = cfs.getFinanceBelong();
			if(c.getReportDate().equals(cfs.getReportDate())){
			     cfs = financedata.getRelativeYearReport(cfs, -1);
			    }
//			CustomerFSRecord cfs1 = financedata.getRelativeYearReport(cfs, -1);//获得去年年报
//			if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)){
			if(!StringX.isSpace(cfs.getReportDate()))extobjx0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAllSubject(cfs);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("400");//销售商品、提供劳务收到的现金
				if(rs!=null){
					extobjx1.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("402");//收到的税费返还
				if(rs!=null){
					extobjx2.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("404");//收到其他与经营活动有关的现金
				if(rs!=null){
					extobjx3.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("406");//经营活动现金流入小计
				if(rs!=null){
					extobjx4.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("407");//购买商品、接受劳务支付的现金
				if(rs!=null){
					extobjx5.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("410");//支付给职工以及为职工支付的现金
				if(rs!=null){
					extobjx6.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("412");//支付的各项税费
				if(rs!=null){
					extobjx7.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("414");//支付其他与经营活动有关的现金
				if(rs!=null){
					extobjx8.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("416");//经营活动现金流出小计
				if(rs!=null){
					extobjx9.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("418");//经营活动产生的现金流量净额
				if(rs!=null){
					extobjx10.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("420");//收回投资收到的现金
				if(rs!=null){
					extobjx11.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("422");//取得投资收益收到的现金
				if(rs!=null){
					extobjx12.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("424");//处置固定资产、无形资产和其他长期资产收回的现金净额
				if(rs!=null){
					extobjx13.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("428");//收到其他与投资活动有关的现金
				if(rs!=null){
					extobjx14.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("430");//投资活动现金流入小计
				if(rs!=null){
					extobjx15.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("432");//购建固定资产、无形资产和其他长期资产支付的现金
				if(rs!=null){
					extobjx16.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("434");//投资所支付的现金
				if(rs!=null){
					extobjx17.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("438");//支付其他与投资活动有关的现金
				if(rs!=null){
					extobjx18.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("440");//投资活动现金流出小计
				if(rs!=null){
					extobjx19.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("442");//投资活动产生的现金流量净额
				if(rs!=null){
					extobjx20.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("444");//吸收投资所收到的现金
				if(rs!=null){
					extobjx21.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("446");//借款收到的现金
				if(rs!=null){
					extobjx22.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("448");//收到其他与筹资活动有关的现金
				if(rs!=null){
					extobjx23.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("450");//筹资活动现金流入小计
				if(rs!=null){
					extobjx24.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("452");//偿还债务支付的现金
				if(rs!=null){
					extobjx25.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("454");//分配股利、利润或偿付利息所支付的现金
				if(rs!=null){
					extobjx26.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("456");//支付其他与筹资活动有关的现金
				if(rs!=null){
					extobjx27.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("458");//筹资活动现金流出小计
				if(rs!=null){
					extobjx28.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("460");//筹资活动产生的现金流量净额
				if(rs!=null){
					extobjx29.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("462");//汇率变动对现金的影响
				if(rs!=null){
					extobjx30.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("464");//现金及现金等价物净增加额
				if(rs!=null){
					extobjx31.setAttr1(rs.getCol2IntString());
				}

			}
//			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//上两年末
			if(cfs2 != null ){
				extobjx0.setAttr2(cfs2.getReportDate());
				if(!StringX.isSpace(cfs2.getReportDate()))extobjx0.setAttr2("("+cfs2.getReportDate()+")");
				double d1;
				reportMap = financedata.getAllSubject(cfs2);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("400");
					if(rs!=null){
						extobjx1.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx1.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx1.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx1.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("402");
					if(rs!=null){
						extobjx2.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx2.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx2.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx2.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("404");
					if(rs!=null){
						extobjx3.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx3.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx3.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx3.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("406");
					if(rs!=null){
						extobjx4.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx4.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx4.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx4.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("407");
					if(rs!=null){
						extobjx5.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx5.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx5.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx5.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("410");
					if(rs!=null){
						extobjx6.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx6.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx6.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx6.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("412");
					if(rs!=null){
						extobjx7.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx7.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx7.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx7.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("414");
					if(rs!=null){
						extobjx8.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx8.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx8.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx8.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("416");
					if(rs!=null){
						extobjx9.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx9.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx9.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx9.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("418");
					if(rs!=null){
						extobjx10.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx10.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx10.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx10.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("420");
					if(rs!=null){
						extobjx11.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx11.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx11.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx11.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("422");
					if(rs!=null){
						extobjx12.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx12.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx12.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx12.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("424");
					if(rs!=null){
						extobjx13.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx13.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx13.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx13.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("428");
					if(rs!=null){
						extobjx14.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx14.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx14.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx14.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("430");
					if(rs!=null){
						extobjx15.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx15.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx15.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx15.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("432");
					if(rs!=null){
						extobjx16.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx16.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx16.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx16.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("434");
					if(rs!=null){
						extobjx17.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx17.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx17.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx17.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("438");
					if(rs!=null){
						extobjx18.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx18.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx18.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx18.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("440");
					if(rs!=null){
						extobjx19.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx19.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx19.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx19.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("442");
					if(rs!=null){
						extobjx20.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx20.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx20.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx20.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("444");
					if(rs!=null){
						extobjx21.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx21.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx21.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx21.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("446");
					if(rs!=null){
						extobjx22.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx22.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx22.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx22.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("448");
					if(rs!=null){
						extobjx23.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx23.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx23.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx23.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("450");
					if(rs!=null){
						extobjx24.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx24.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx24.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx24.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("452");
					if(rs!=null){
						extobjx25.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx25.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx25.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx25.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("454");
					if(rs!=null){
						extobjx26.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx26.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx26.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx26.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("456");
					if(rs!=null){
						extobjx27.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx27.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx27.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx27.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("458");
					if(rs!=null){
						extobjx28.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx28.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx28.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx28.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("460");
					if(rs!=null){
						extobjx29.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx29.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx29.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx29.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("462");
					if(rs!=null){
						extobjx30.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx30.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx30.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx30.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("464");
					if(rs!=null){
						extobjx31.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx31.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx31.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx31.setAttr4("");
						}
					}

				}
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//上三年末
			if(cfs3 != null ){
				if(!StringX.isSpace(cfs3.getReportDate()))extobjx0.setAttr3("("+cfs3.getReportDate()+")");
				reportMap = financedata.getAllSubject(cfs3);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("400");
					if(rs!=null){
						extobjx1.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("402");
					if(rs!=null){
						extobjx2.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("404");
					if(rs!=null){
						extobjx3.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("406");
					if(rs!=null){
						extobjx4.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("407");
					if(rs!=null){
						extobjx5.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("410");
					if(rs!=null){
						extobjx6.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("412");
					if(rs!=null){
						extobjx7.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("414");
					if(rs!=null){
						extobjx8.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("416");
					if(rs!=null){
						extobjx9.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("418");
					if(rs!=null){
						extobjx10.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("420");
					if(rs!=null){
						extobjx11.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("422");
					if(rs!=null){
						extobjx12.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("424");
					if(rs!=null){
						extobjx13.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("428");
					if(rs!=null){
						extobjx14.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("430");
					if(rs!=null){
						extobjx15.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("432");
					if(rs!=null){
						extobjx16.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("434");
					if(rs!=null){
						extobjx17.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("438");
					if(rs!=null){
						extobjx18.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("440");
					if(rs!=null){
						extobjx19.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("442");
					if(rs!=null){
						extobjx20.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("444");
					if(rs!=null){
						extobjx21.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("446");
					if(rs!=null){
						extobjx22.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("448");
					if(rs!=null){
						extobjx23.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("450");
					if(rs!=null){
						extobjx24.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("452");
					if(rs!=null){
						extobjx25.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("454");
					if(rs!=null){
						extobjx26.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("456");
					if(rs!=null){
						extobjx27.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("458");
					if(rs!=null){
						extobjx28.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("460");
					if(rs!=null){
						extobjx29.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("462");
					if(rs!=null){
						extobjx30.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("464");
					if(rs!=null){
						extobjx31.setAttr3(rs.getCol2IntString());
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
		CustomerFSRecord cfs = financedata.getNewYearReport(customerID);
		CustomerFSRecord c = financedata.getNewestReport(customerID);
		if(cfs != null){
		//现金流量表
			reportType = cfs.getFinanceBelong();
			if(c.getReportDate().equals(cfs.getReportDate())){
			     cfs = financedata.getRelativeYearReport(cfs, -1);
			    }
			if(!StringX.isSpace(cfs.getReportDate()))extobjx0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getAllSubject(cfs);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("400");
				if(rs!=null){
					extobjx1.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("402");
				if(rs!=null){
					extobjx2.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("404");
				if(rs!=null){
					extobjx3.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("406");
				if(rs!=null){
					extobjx4.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("407");
				if(rs!=null){
					extobjx5.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("410");
				if(rs!=null){
					extobjx6.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("412");
				if(rs!=null){
					extobjx7.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("414");
				if(rs!=null){
					extobjx8.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("416");
				if(rs!=null){
					extobjx9.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("418");
				if(rs!=null){
					extobjx10.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("420");
				if(rs!=null){
					extobjx11.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("422");
				if(rs!=null){
					extobjx12.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("424");
				if(rs!=null){
					extobjx13.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("426");//处置子公司及其他营业单位收到的现金净额
				if(rs!=null){
					extobjx14.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("428");
				if(rs!=null){
					extobjx15.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("430");
				if(rs!=null){
					extobjx16.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("432");
				if(rs!=null){
					extobjx17.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("434");//投资支付的现金
				if(rs!=null){
					extobjx18.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("436");//取得子公司及其他营业单位支付的现金净额
				if(rs!=null){
					extobjx19.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("438");
				if(rs!=null){
					extobjx20.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("440");
				if(rs!=null){
					extobjx21.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("442");
				if(rs!=null){
					extobjx22.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("444");//吸收投资收到的现金
				if(rs!=null){
					extobjx23.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("446");
				if(rs!=null){
					extobjx24.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("448");
				if(rs!=null){
					extobjx25.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("450");
				if(rs!=null){
					extobjx26.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("452");
				if(rs!=null){
					extobjx27.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("454");//分配股利、利润或偿付利息支付的现金
				if(rs!=null){
					extobjx28.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("456");
				if(rs!=null){
					extobjx29.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("458");
				if(rs!=null){
					extobjx30.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("460");
				if(rs!=null){
					extobjx31.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("462");//汇率变动对现金的影响额
				if(rs!=null){
					extobjx32.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("464");
				if(rs!=null){
					extobjx33.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("466");//加：期初现金及现金等价物余额
				if(rs!=null){
					extobjx34.setAttr1(rs.getCol2IntString());
				}
				rs = (ReportSubject) reportMap.get("468");//期末现金及现金等价物余额
				if(rs!=null){
					extobjx35.setAttr1(rs.getCol2IntString());
				}

			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//上两年末
			if(cfs2 != null ){
				double d1;
				if(!StringX.isSpace(cfs2.getReportDate()))extobjx0.setAttr2("("+cfs2.getReportDate()+")");
				reportMap = financedata.getAllSubject(cfs2);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("400");
					if(rs!=null){
						extobjx1.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx1.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx1.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx1.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("402");
					if(rs!=null){
						extobjx2.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx2.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx2.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx2.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("404");
					if(rs!=null){
						extobjx3.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx3.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx3.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx3.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("406");
					if(rs!=null){
						extobjx4.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx4.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx4.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx4.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("407");
					if(rs!=null){
						extobjx5.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx5.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx5.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx5.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("410");
					if(rs!=null){
						extobjx6.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx6.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx6.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx6.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("412");
					if(rs!=null){
						extobjx7.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx7.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx7.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx7.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("414");
					if(rs!=null){
						extobjx8.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx8.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx8.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx8.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("416");if(rs!=null){
						extobjx9.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx9.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx9.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx9.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("418");
					if(rs!=null){
						extobjx10.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx10.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx10.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx10.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("420");
					if(rs!=null){
						extobjx11.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx11.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx11.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx11.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("422");
					if(rs!=null){
						extobjx12.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx12.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx12.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx12.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("424");
					if(rs!=null){
						extobjx13.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx13.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx13.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx13.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("426");
					if(rs!=null){
						extobjx14.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx14.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx14.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx14.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("428");
					if(rs!=null){
						extobjx15.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx15.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx15.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx15.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("430");
					if(rs!=null){
						extobjx16.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx16.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx16.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx16.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("432");
					if(rs!=null){
						extobjx17.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx17.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx17.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx17.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("434");
					if(rs!=null){
						extobjx18.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx18.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx18.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx18.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("436");
					if(rs!=null){
						extobjx19.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx19.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx19.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx19.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("438");
					if(rs!=null){
						extobjx20.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx20.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx20.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx20.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("440");
					if(rs!=null){
						extobjx21.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx21.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx21.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx21.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("442");
					if(rs!=null){
						extobjx22.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx22.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx22.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx22.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("444");
					if(rs!=null){
						extobjx23.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx23.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx23.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx23.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("446");
					if(rs!=null){
						extobjx24.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx24.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx24.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx24.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("448");
					if(rs!=null){
						extobjx25.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx25.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx25.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx25.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("450");
					if(rs!=null){
						extobjx26.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx26.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx26.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx26.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("452");
					if(rs!=null){
						extobjx27.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx27.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx27.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx27.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("454");
					if(rs!=null){
						extobjx28.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx28.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx28.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx28.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("456");
					if(rs!=null){
						extobjx29.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx29.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx29.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx29.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("458");
					if(rs!=null){
						extobjx30.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx30.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx30.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx30.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("460");
					if(rs!=null){
						extobjx31.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx31.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx31.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx31.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("462");
					if(rs!=null){
						extobjx32.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx32.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx32.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx32.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx32.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("464");
					if(rs!=null){
						extobjx33.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx33.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx33.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx33.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx33.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("466");
					if(rs!=null){
						extobjx34.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx34.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx34.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx34.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx34.setAttr4("");
						}
					}
					rs = (ReportSubject) reportMap.get("468");
					if(rs!=null){
						extobjx35.setAttr2(rs.getCol2IntString());
						if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx35.getAttr1()!=null){
							d1 = (Double.parseDouble(extobjx35.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
							extobjx35.setAttr4(String.format("%.0f",d1*100));
						}else {
							extobjx35.setAttr4("");
						}
					}

				}
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//上三年末
			if(cfs3 != null ){
				if(!StringX.isSpace(cfs3.getReportDate()))extobjx0.setAttr3("("+cfs3.getReportDate()+")");
				reportMap = financedata.getAllSubject(cfs3);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("400");
					if(rs!=null){
						extobjx1.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("402");
					if(rs!=null){
						extobjx2.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("404");
					if(rs!=null){
						extobjx3.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("406");
					if(rs!=null){
						extobjx4.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("407");
					if(rs!=null){
						extobjx5.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("410");
					if(rs!=null){
						extobjx6.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("412");
					if(rs!=null){
						extobjx7.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("414");
					if(rs!=null){
						extobjx8.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("416");
					if(rs!=null){
						extobjx9.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("418");
					if(rs!=null){
						extobjx10.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("420");
					if(rs!=null){
						extobjx11.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("422");
					if(rs!=null){
						extobjx12.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("424");
					if(rs!=null){
						extobjx13.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("426");
					if(rs!=null){
						extobjx14.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("428");
					if(rs!=null){
						extobjx15.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("430");
					if(rs!=null){
						extobjx16.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("432");
					if(rs!=null){
						extobjx17.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("434");
					if(rs!=null){
						extobjx18.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("436");
					if(rs!=null){
						extobjx19.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("438");
					if(rs!=null){
						extobjx20.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("440");
					if(rs!=null){
						extobjx21.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("442");
					if(rs!=null){
						extobjx22.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("444");
					if(rs!=null){
						extobjx23.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("446");
					if(rs!=null){
						extobjx24.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("448");
					if(rs!=null){
						extobjx25.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("450");
					if(rs!=null){
						extobjx26.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("452");
					if(rs!=null){
						extobjx27.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("454");
					if(rs!=null){
						extobjx28.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("456");
					if(rs!=null){
						extobjx29.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("458");
					if(rs!=null){
						extobjx30.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("460");
					if(rs!=null){
						extobjx31.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("462");
					if(rs!=null){
						extobjx32.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("464");
					if(rs!=null){
						extobjx33.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("466");
					if(rs!=null){
						extobjx34.setAttr3(rs.getCol2IntString());
					}
					rs = (ReportSubject) reportMap.get("468");
					if(rs!=null){
						extobjx35.setAttr3(rs.getCol2IntString());
					}

				}
			}
		}
	}

	
	public void getAssure(){
		ReportSubject rs = null;
		FinanceDataManager financedata = new FinanceDataManager();
		CustomerFSRecord cfs = financedata.getNewYearReport(customerID);//本期
		if(cfs != null){
			String reportType = cfs.getFinanceBelong();
			if(!StringX.isSpace(cfs.getReportDate()))extobjx0.setAttr1("("+cfs.getReportDate()+")");
			Map reportMap = financedata.getCashMap(cfs);
			if(reportMap.size()>0){
				rs = (ReportSubject) reportMap.get("收到的担保费收入");
				extobjx1.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收到的税费返还");
				extobjx2.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收到其他与经营活动有关的现金");
				extobjx3.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("经营活动现金流入小计");
				extobjx4.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("担保代偿支付的现金");
				extobjx5.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("支付给职工以及为职工支付的现金");
				extobjx6.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("支付的各项税费");
				extobjx7.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("支付其他与经营活动有关的现金");
				extobjx8.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("经营活动现金流出小计");
				extobjx9.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("经营活动产生的现金流量净额");
				extobjx10.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收回投资收到的现金");
				extobjx11.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("取得投资收益收到的现金");
				extobjx12.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("处置固定资产、无形资产和其他长期资产收回的现金净额");
				extobjx13.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收到其他与投资活动有关的现金");
				extobjx14.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("投资活动现金流入小计");
				extobjx15.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("购建固定资产、无形资产和其他长期资产支付的现金");
				extobjx16.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("投资所支付的现金");
				extobjx17.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("支付其他与投资活动有关的现金");
				extobjx18.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("投资活动现金流出小计");
				extobjx19.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("投资活动产生的现金流量净额");
				extobjx20.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("吸收投资所收到的现金");
				extobjx21.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("借款收到的现金");
				extobjx22.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("收到其他与筹资活动有关的现金");
				extobjx23.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流入小计");
				extobjx24.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("偿还债务支付的现金");
				extobjx25.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("分配股利、利润或偿付利息所支付的现金");
				extobjx26.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("支付其他与筹资活动有关的现金");
				extobjx27.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("筹资活动现金流出小计");
				extobjx28.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("筹资活动产生的现金流量净额");
				extobjx29.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("汇率变动对现金的影响额");
				extobjx30.setAttr1(rs.getCol2ValueString());
				rs = (ReportSubject) reportMap.get("现金及现金等价物净增加额");
				extobjx31.setAttr1(rs.getCol2ValueString());
			}
			
			CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//上两年末
			if(cfs2 != null && cfs2.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs2.getReportDate()))extobjx0.setAttr2("("+cfs2.getReportDate()+")");
				double d1;
				reportMap = financedata.getCashMap(cfs2);
				rs = (ReportSubject) reportMap.get("收到的担保费收入");
				extobjx1.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx1.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx1.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx1.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx1.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到的税费返还");
				extobjx2.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx2.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx2.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx2.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx2.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到其他与经营活动有关的现金");
				extobjx3.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx3.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx3.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx3.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx3.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("经营活动现金流入小计");
				extobjx4.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx4.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx4.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx4.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx4.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("担保代偿支付的现金");
				extobjx5.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx5.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx5.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx5.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx5.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付给职工以及为职工支付的现金");
				extobjx6.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx6.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx6.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx6.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx6.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付的各项税费");
				extobjx7.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx7.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx7.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx7.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx7.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付其他与经营活动有关的现金");
				extobjx8.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx8.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx8.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx8.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx8.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("经营活动现金流出小计");
				extobjx9.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx9.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx9.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx9.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx9.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("经营活动产生的现金流量净额");
				extobjx10.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx10.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx10.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx10.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx10.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收回投资收到的现金");
				extobjx11.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx11.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx11.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx11.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx11.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("取得投资收益收到的现金");
				extobjx12.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx12.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx12.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx12.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx12.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("处置固定资产、无形资产和其他长期资产收回的现金净额");
				extobjx13.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx13.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx13.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx13.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx13.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到其他与投资活动有关的现金");
				extobjx14.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx14.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx14.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx14.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx14.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资活动现金流入小计");
				extobjx15.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx15.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx15.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx15.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx15.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("购建固定资产、无形资产和其他长期资产支付的现金");
				extobjx16.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx16.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx16.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx16.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx16.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资所支付的现金");
				extobjx17.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx17.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx17.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx17.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx17.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付其他与投资活动有关的现金");
				extobjx18.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx18.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx18.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx18.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx18.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资活动现金流出小计");
				extobjx19.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx19.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx19.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx19.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx19.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("投资活动产生的现金流量净额");
				extobjx20.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx20.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx20.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx20.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx20.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("吸收投资所收到的现金");
				extobjx21.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx21.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx21.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx21.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx21.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("借款收到的现金");
				extobjx22.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx22.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx22.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx22.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx22.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("收到其他与筹资活动有关的现金");
				extobjx23.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx23.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx23.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx23.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx23.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("筹资活动现金流入小计");
				extobjx24.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx24.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx24.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx24.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx24.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("偿还债务支付的现金");
				extobjx25.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx25.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx25.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx25.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx25.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("分配股利、利润或偿付利息所支付的现金");
				extobjx26.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx26.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx26.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx26.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx26.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("支付其他与筹资活动有关的现金");
				extobjx27.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx27.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx27.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx27.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx27.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("筹资活动现金流出小计");
				extobjx28.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx28.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx28.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx28.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx28.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("筹资活动产生的现金流量净额");
				extobjx29.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx29.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx29.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx29.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx29.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("汇率变动对现金的影响额");
				extobjx30.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx30.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx30.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx30.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx30.setAttr4("");
				}
				rs = (ReportSubject) reportMap.get("现金及现金等价物净增加额");
				extobjx31.setAttr2(rs.getCol2ValueString());
				if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobjx31.getAttr1()!=null){
					d1 = (Double.parseDouble(extobjx31.getAttr1())-rs.getCol2Value())/rs.getCol2Value();
					extobjx31.setAttr4(String.format("%.2f",d1));
				}else {
					extobjx31.setAttr4("");
				}
			}
			
			CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//上三年末
			if(cfs3 != null && cfs3.getFinanceBelong().equals(reportType)){
				if(!StringX.isSpace(cfs3.getReportDate()))extobjx0.setAttr3("("+cfs3.getReportDate()+")");
				reportMap = financedata.getCashMap(cfs3);
				if(reportMap.size()>0){
					rs = (ReportSubject) reportMap.get("收到的担保费收入");
					extobjx1.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("收到的税费返还");
					extobjx2.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("收到其他与经营活动有关的现金");
					extobjx3.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("经营活动现金流入小计");
					extobjx4.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("担保代偿支付的现金");
					extobjx5.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("支付给职工以及为职工支付的现金");
					extobjx6.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("支付的各项税费");
					extobjx7.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("支付其他与经营活动有关的现金");
					extobjx8.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("经营活动现金流出小计");
					extobjx9.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("经营活动产生的现金流量净额");
					extobjx10.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("收回投资收到的现金");
					extobjx11.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("取得投资收益收到的现金");
					extobjx12.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("处置固定资产、无形资产和其他长期资产收回的现金净额");
					extobjx13.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("收到其他与投资活动有关的现金");
					extobjx14.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("投资活动现金流入小计");
					extobjx15.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("购建固定资产、无形资产和其他长期资产支付的现金");
					extobjx16.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("投资所支付的现金");
					extobjx17.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("支付其他与投资活动有关的现金");
					extobjx18.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("投资活动现金流出小计");
					extobjx19.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("投资活动产生的现金流量净额");
					extobjx20.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("吸收投资所收到的现金");
					extobjx21.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("借款收到的现金");
					extobjx22.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("收到其他与筹资活动有关的现金");
					extobjx23.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("筹资活动现金流入小计");
					extobjx24.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("偿还债务支付的现金");
					extobjx25.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("分配股利、利润或偿付利息所支付的现金");
					extobjx26.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("支付其他与筹资活动有关的现金");
					extobjx27.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("筹资活动现金流出小计");
					extobjx28.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("筹资活动产生的现金流量净额");
					extobjx29.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("汇率变动对现金的影响额");
					extobjx30.setAttr3(rs.getCol2ValueString());
					rs = (ReportSubject) reportMap.get("现金及现金等价物净增加额");
					extobjx31.setAttr3(rs.getCol2ValueString());
				}
			}
		}
	}
	
	public DocExtClass getExtobjx0() {
		return extobjx0;
	}

	public void setExtobjx0(DocExtClass extobjx0) {
		this.extobjx0 = extobjx0;
	}

	public DocExtClass getExtobjx1() {
		return extobjx1;
	}

	public void setExtobjx1(DocExtClass extobjx1) {
		this.extobjx1 = extobjx1;
	}

	public DocExtClass getExtobjx2() {
		return extobjx2;
	}

	public void setExtobjx2(DocExtClass extobjx2) {
		this.extobjx2 = extobjx2;
	}

	public DocExtClass getExtobjx3() {
		return extobjx3;
	}

	public void setExtobjx3(DocExtClass extobjx3) {
		this.extobjx3 = extobjx3;
	}

	public DocExtClass getExtobjx4() {
		return extobjx4;
	}

	public void setExtobjx4(DocExtClass extobjx4) {
		this.extobjx4 = extobjx4;
	}

	public DocExtClass getExtobjx5() {
		return extobjx5;
	}

	public void setExtobjx5(DocExtClass extobjx5) {
		this.extobjx5 = extobjx5;
	}

	public DocExtClass getExtobjx6() {
		return extobjx6;
	}

	public void setExtobjx6(DocExtClass extobjx6) {
		this.extobjx6 = extobjx6;
	}

	public DocExtClass getExtobjx7() {
		return extobjx7;
	}

	public void setExtobjx7(DocExtClass extobjx7) {
		this.extobjx7 = extobjx7;
	}

	public DocExtClass getExtobjx8() {
		return extobjx8;
	}

	public void setExtobjx8(DocExtClass extobjx8) {
		this.extobjx8 = extobjx8;
	}

	public DocExtClass getExtobjx9() {
		return extobjx9;
	}

	public void setExtobjx9(DocExtClass extobjx9) {
		this.extobjx9 = extobjx9;
	}

	public DocExtClass getExtobjx10() {
		return extobjx10;
	}

	public void setExtobjx10(DocExtClass extobjx10) {
		this.extobjx10 = extobjx10;
	}

	public DocExtClass getExtobjx11() {
		return extobjx11;
	}

	public void setExtobjx11(DocExtClass extobjx11) {
		this.extobjx11 = extobjx11;
	}

	public DocExtClass getExtobjx12() {
		return extobjx12;
	}

	public void setExtobjx12(DocExtClass extobjx12) {
		this.extobjx12 = extobjx12;
	}

	public DocExtClass getExtobjx13() {
		return extobjx13;
	}

	public void setExtobjx13(DocExtClass extobjx13) {
		this.extobjx13 = extobjx13;
	}

	public DocExtClass getExtobjx14() {
		return extobjx14;
	}

	public void setExtobjx14(DocExtClass extobjx14) {
		this.extobjx14 = extobjx14;
	}

	public DocExtClass getExtobjx15() {
		return extobjx15;
	}

	public void setExtobjx15(DocExtClass extobjx15) {
		this.extobjx15 = extobjx15;
	}

	public DocExtClass getExtobjx16() {
		return extobjx16;
	}

	public void setExtobjx16(DocExtClass extobjx16) {
		this.extobjx16 = extobjx16;
	}

	public DocExtClass getExtobjx17() {
		return extobjx17;
	}

	public void setExtobjx17(DocExtClass extobjx17) {
		this.extobjx17 = extobjx17;
	}

	public DocExtClass getExtobjx18() {
		return extobjx18;
	}

	public void setExtobjx18(DocExtClass extobjx18) {
		this.extobjx18 = extobjx18;
	}

	public DocExtClass getExtobjx19() {
		return extobjx19;
	}

	public void setExtobjx19(DocExtClass extobjx19) {
		this.extobjx19 = extobjx19;
	}

	public DocExtClass getExtobjx20() {
		return extobjx20;
	}

	public void setExtobjx20(DocExtClass extobjx20) {
		this.extobjx20 = extobjx20;
	}

	public DocExtClass getExtobjx21() {
		return extobjx21;
	}

	public void setExtobjx21(DocExtClass extobjx21) {
		this.extobjx21 = extobjx21;
	}

	public DocExtClass getExtobjx22() {
		return extobjx22;
	}

	public void setExtobjx22(DocExtClass extobjx22) {
		this.extobjx22 = extobjx22;
	}

	public DocExtClass getExtobjx23() {
		return extobjx23;
	}

	public void setExtobjx23(DocExtClass extobjx23) {
		this.extobjx23 = extobjx23;
	}

	public DocExtClass getExtobjx24() {
		return extobjx24;
	}

	public void setExtobjx24(DocExtClass extobjx24) {
		this.extobjx24 = extobjx24;
	}

	public DocExtClass getExtobjx25() {
		return extobjx25;
	}

	public void setExtobjx25(DocExtClass extobjx25) {
		this.extobjx25 = extobjx25;
	}

	public DocExtClass getExtobjx26() {
		return extobjx26;
	}

	public void setExtobjx26(DocExtClass extobjx26) {
		this.extobjx26 = extobjx26;
	}

	public DocExtClass getExtobjx27() {
		return extobjx27;
	}

	public void setExtobjx27(DocExtClass extobjx27) {
		this.extobjx27 = extobjx27;
	}

	public DocExtClass getExtobjx28() {
		return extobjx28;
	}

	public void setExtobjx28(DocExtClass extobjx28) {
		this.extobjx28 = extobjx28;
	}

	public DocExtClass getExtobjx29() {
		return extobjx29;
	}

	public void setExtobjx29(DocExtClass extobjx29) {
		this.extobjx29 = extobjx29;
	}

	public DocExtClass getExtobjx30() {
		return extobjx30;
	}

	public void setExtobjx30(DocExtClass extobjx30) {
		this.extobjx30 = extobjx30;
	}

	public DocExtClass getExtobjx31() {
		return extobjx31;
	}

	public void setExtobjx31(DocExtClass extobjx31) {
		this.extobjx31 = extobjx31;
	}

	public DocExtClass getExtobjx32() {
		return extobjx32;
	}

	public void setExtobjx32(DocExtClass extobjx32) {
		this.extobjx32 = extobjx32;
	}

	public DocExtClass getExtobjx33() {
		return extobjx33;
	}

	public void setExtobjx33(DocExtClass extobjx33) {
		this.extobjx33 = extobjx33;
	}

	public DocExtClass getExtobjx34() {
		return extobjx34;
	}

	public void setExtobjx34(DocExtClass extobjx34) {
		this.extobjx34 = extobjx34;
	}

	public DocExtClass getExtobjx35() {
		return extobjx35;
	}

	public void setExtobjx35(DocExtClass extobjx35) {
		this.extobjx35 = extobjx35;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}
}

