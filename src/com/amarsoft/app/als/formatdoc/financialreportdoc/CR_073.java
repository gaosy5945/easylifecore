package com.amarsoft.app.als.formatdoc.financialreportdoc;

import java.io.Serializable;
import java.util.Map;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.finance.analyse.model.ReportSubject;
import com.amarsoft.app.als.formatdoc.DocExtClass;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.biz.formatdoc.model.FormatDocData;

/**
 * 现金流量表（旧会计准则）
 * @author Administrator
 *
 */
public class CR_073 extends FormatDocData implements Serializable{
	private static final long serialVersionUID = 1L;
	private String opinion1="";
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
    private DocExtClass extobj23;
    private DocExtClass extobj24;
    private DocExtClass extobj25;
    private DocExtClass extobj26;
    private DocExtClass extobj27;
    private DocExtClass extobj28;
    private DocExtClass extobj29;
    private DocExtClass extobj30;
    private DocExtClass extobj31;

	public boolean initObjectForRead() {
		ARE.getLog().trace("CR_073.initObject()");
		
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		
		String sCustomerID = "";
		String reportType = "";
	
		try {
			
			sCustomerID = getCustomerMsg(sObjectNo);
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
			extobj23 = new DocExtClass();
			extobj24 = new DocExtClass();
			extobj25 = new DocExtClass();
			extobj26 = new DocExtClass();
			extobj27 = new DocExtClass();
			extobj28 = new DocExtClass();
			extobj29 = new DocExtClass();
			extobj30 = new DocExtClass();
			extobj31 = new DocExtClass();
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				ReportSubject rs = null;
				FinanceDataManager financedata = new FinanceDataManager();
				CustomerFSRecord c = financedata.getNewestReport(sCustomerID);//本期
				CustomerFSRecord cfs = financedata.getNewYearReport(sCustomerID);//最新一期年报
				if(cfs != null){
					reportType = cfs.getFinanceBelong();
					 if(c.getReportDate().equals(cfs.getReportDate())){
	 				     cfs = financedata.getRelativeYearReport(cfs, -1);
					    }
//					CustomerFSRecord cfs1 = financedata.getRelativeYearReport(cfs, -1);//获得去年年报
//					if(cfs1 != null && cfs1.getFinanceBelong().equals(reportType)){
					if(!StringX.isSpace(cfs.getReportDate()))extobj0.setAttr1("("+cfs.getReportDate()+")");
					Map reportMap = financedata.getAllSubject(cfs);
					if(reportMap.size()>0){
						rs = (ReportSubject) reportMap.get("400");//销售商品、提供劳务收到的现金
						if(rs!=null){
							extobj1.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("402");//收到的税费返还
						if(rs!=null){
							extobj2.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("404");//收到其他与经营活动有关的现金
						if(rs!=null){
							extobj3.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("406");//经营活动现金流入小计
						if(rs!=null){
							extobj4.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("407");//购买商品、接受劳务支付的现金
						if(rs!=null){
							extobj5.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("410");//支付给职工以及为职工支付的现金
						if(rs!=null){
							extobj6.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("412");//支付的各项税费
						if(rs!=null){
							extobj7.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("414");//支付其他与经营活动有关的现金
						if(rs!=null){
							extobj8.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("416");//经营活动现金流出小计
						if(rs!=null){
							extobj9.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("418");//经营活动产生的现金流量净额
						if(rs!=null){
							extobj10.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("420");//收回投资收到的现金
						if(rs!=null){
							extobj11.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("422");//取得投资收益收到的现金
						if(rs!=null){
							extobj12.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("424");//处置固定资产、无形资产和其他长期资产收回的现金净额
						if(rs!=null){
							extobj13.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("428");//收到其他与投资活动有关的现金
						if(rs!=null){
							extobj14.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("430");//投资活动现金流入小计
						if(rs!=null){
							extobj15.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("432");//购建固定资产、无形资产和其他长期资产支付的现金
						if(rs!=null){
							extobj16.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("434");//投资所支付的现金
						if(rs!=null){
							extobj17.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("438");//支付其他与投资活动有关的现金
						if(rs!=null){
							extobj18.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("440");//投资活动现金流出小计
						if(rs!=null){
							extobj19.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("442");//投资活动产生的现金流量净额
						if(rs!=null){
							extobj20.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("444");//吸收投资所收到的现金
						if(rs!=null){
							extobj21.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("446");//借款收到的现金
						if(rs!=null){
							extobj22.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("448");//收到其他与筹资活动有关的现金
						if(rs!=null){
							extobj23.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("450");//筹资活动现金流入小计
						if(rs!=null){
							extobj24.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("452");//偿还债务支付的现金
						if(rs!=null){
							extobj25.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("454");//分配股利、利润或偿付利息所支付的现金
						if(rs!=null){
							extobj26.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("456");//支付其他与筹资活动有关的现金
						if(rs!=null){
							extobj27.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("458");//筹资活动现金流出小计
						if(rs!=null){
							extobj28.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("460");//筹资活动产生的现金流量净额
						if(rs!=null){
							extobj29.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("462");//汇率变动对现金的影响
						if(rs!=null){
							extobj30.setAttr1(rs.getCol2IntString());
						}
						rs = (ReportSubject) reportMap.get("464");//现金及现金等价物净增加额
						if(rs!=null){
							extobj31.setAttr1(rs.getCol2IntString());
						}
					}
//					}
					
					CustomerFSRecord cfs2 = financedata.getRelativeYearReport(cfs, -1);//上两年末
					if(cfs2 != null ){
						double d1;
						if(!StringX.isSpace(cfs2.getReportDate()))extobj0.setAttr2("("+cfs2.getReportDate()+")");
						reportMap = financedata.getAllSubject(cfs2);
						if(reportMap.size()>0){
							rs = (ReportSubject) reportMap.get("400");
							if(rs!=null){
								extobj1.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj1.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj1.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj1.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj1.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("402");
							if(rs!=null){
								extobj2.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj2.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj2.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj2.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj2.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("404");
							if(rs!=null){
								extobj3.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj3.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj3.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj3.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj3.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("406");
							if(rs!=null){
								extobj4.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj4.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj4.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj4.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj4.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("407");
							if(rs!=null){
								extobj5.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj5.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj5.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj5.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj5.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("410");
							if(rs!=null){
								extobj6.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj6.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj6.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj6.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj6.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("412");
							if(rs!=null){
								extobj7.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj7.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj7.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj7.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj7.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("414");
							if(rs!=null){
								extobj8.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj8.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj8.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj8.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj8.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("416");
							if(rs!=null){
								extobj9.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj9.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj9.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj9.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj9.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("418");
							if(rs!=null){
								extobj10.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj10.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj10.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj10.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj10.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("420");
							if(rs!=null){
								extobj11.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj11.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj11.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj11.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj11.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("422");
							if(rs!=null){
								extobj12.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj12.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj12.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj12.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj12.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("424");
							if(rs!=null){
								extobj13.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj13.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj13.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj13.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj13.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("428");
							if(rs!=null){
								extobj14.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj14.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj14.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj14.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj14.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("430");
							if(rs!=null){
								extobj15.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj15.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj15.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj15.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj15.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("432");
							if(rs!=null){
								extobj16.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj16.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj16.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj16.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj16.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("434");
							if(rs!=null){
								extobj17.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj17.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj17.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj17.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj17.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("438");
							if(rs!=null){
								extobj18.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj18.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj18.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj18.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj18.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("440");
							if(rs!=null){
								extobj19.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj19.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj19.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj19.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj19.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("442");
							if(rs!=null){
								extobj20.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj20.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj20.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj20.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj20.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("444");
							if(rs!=null){
								extobj21.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj21.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj21.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj21.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj21.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("446");
							if(rs!=null){
								extobj22.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj22.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj22.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj22.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj22.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("448");
							if(rs!=null){
								extobj23.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj23.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj23.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj23.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj23.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("450");
							if(rs!=null){
								extobj24.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj24.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj24.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj24.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj24.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("452");
							if(rs!=null){
								extobj25.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj25.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj25.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj25.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj25.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("454");
							if(rs!=null){
								extobj26.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj26.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj26.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj26.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj26.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("456");
							if(rs!=null){
								extobj27.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj27.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj27.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj27.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj27.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("458");
							if(rs!=null){
								extobj28.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj28.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj28.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj28.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj28.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("460");
							if(rs!=null){
								extobj29.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj29.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj29.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj29.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj29.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("462");
							if(rs!=null){
								extobj30.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj30.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj30.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj30.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj30.setAttr4("");
								}
							}
							rs = (ReportSubject) reportMap.get("464");
							if(rs!=null){
								extobj31.setAttr2(rs.getCol2IntString());
								if(String.valueOf(rs.getCol2Value())!=null && rs.getCol2Value()!=0 && extobj31.getAttr1()!=null){
									d1 = (Double.parseDouble(extobj31.getAttr1().replace(",",""))-rs.getCol2Value())/rs.getCol2Value();
									extobj31.setAttr4(String.format("%.0f",d1*100));
								}else {
									extobj31.setAttr4("");
								}
							}
						}
					}
					
					CustomerFSRecord cfs3 = financedata.getRelativeYearReport(cfs, -2);//上三年末
					if(cfs3 != null ){
//						extobj0.setAttr3(cfs3.getReportDate());
						if(!StringX.isSpace(cfs3.getReportDate()))extobj0.setAttr3("("+cfs3.getReportDate()+")");
						reportMap = financedata.getAllSubject(cfs3);
						if(reportMap.size()>0){
							rs = (ReportSubject) reportMap.get("400");
							if(rs!=null){
								extobj1.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("402");
							if(rs!=null){
								extobj2.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("404");
							if(rs!=null){
								extobj3.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("406");
							if(rs!=null){
								extobj4.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("407");
							if(rs!=null){
								extobj5.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("410");
							if(rs!=null){
								extobj6.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("412");
							if(rs!=null){
								extobj7.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("414");
							if(rs!=null){
								extobj8.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("416");
							if(rs!=null){
								extobj9.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("418");
							if(rs!=null){
								extobj10.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("420");
							if(rs!=null){
								extobj11.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("422");
							if(rs!=null){
								extobj12.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("424");
							if(rs!=null){
								extobj13.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("428");
							if(rs!=null){
								extobj14.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("430");
							if(rs!=null){
								extobj15.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("432");
							if(rs!=null){
								extobj16.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("434");
							if(rs!=null){
								extobj17.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("438");
							if(rs!=null){
								extobj18.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("440");
							if(rs!=null){
								extobj19.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("442");
							if(rs!=null){
								extobj20.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("444");
							if(rs!=null){
								extobj21.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("446");
							if(rs!=null){
								extobj22.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("448");
							if(rs!=null){
								extobj23.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("450");
							if(rs!=null){
								extobj24.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("452");
							if(rs!=null){
								extobj25.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("454");
							if(rs!=null){
								extobj26.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("456");
							if(rs!=null){
								extobj27.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("458");
							if(rs!=null){
								extobj28.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("460");
							if(rs!=null){
								extobj29.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("462");
							if(rs!=null){
								extobj30.setAttr3(rs.getCol2IntString());
							}
							rs = (ReportSubject) reportMap.get("464");
							if(rs!=null){
								extobj31.setAttr3(rs.getCol2IntString());
							}
						}
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
		return true;
	}

	private String getCustomerMsg(String sObjectNo){
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String customerID="";
		try {
			m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
			q = m.createQuery("SERIALNO=:SERIALNO").setParameter("SERIALNO",sObjectNo);
			bo = q.getSingleResult();
			if(bo != null){
				customerID=bo.getAttribute("CustomerID").getString();
				m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
				q = m.createQuery("CustomerID=:customerID").setParameter("customerID", customerID);
				bo = q.getSingleResult();
				if(bo != null){
					String customerType = bo.getAttribute("CustomerType").getString();
					if("0210".equals(customerType)){
						m = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
						q = m.createQuery("GroupID=:GroupID").setParameter("GroupID", customerID);
						BizObject bb = q.getSingleResult();
						if(bb != null){
							customerID = bb.getAttribute("FkeyMembercustomerID").getString();
						}
					}
				}
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customerID;
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

	public DocExtClass getExtobj26() {
		return extobj26;
	}

	public void setExtobj26(DocExtClass extobj26) {
		this.extobj26 = extobj26;
	}

	public DocExtClass getExtobj27() {
		return extobj27;
	}

	public void setExtobj27(DocExtClass extobj27) {
		this.extobj27 = extobj27;
	}

	public DocExtClass getExtobj28() {
		return extobj28;
	}

	public void setExtobj28(DocExtClass extobj28) {
		this.extobj28 = extobj28;
	}

	public DocExtClass getExtobj29() {
		return extobj29;
	}

	public void setExtobj29(DocExtClass extobj29) {
		this.extobj29 = extobj29;
	}

	public DocExtClass getExtobj30() {
		return extobj30;
	}

	public void setExtobj30(DocExtClass extobj30) {
		this.extobj30 = extobj30;
	}

	public DocExtClass getExtobj31() {
		return extobj31;
	}

	public void setExtobj31(DocExtClass extobj31) {
		this.extobj31 = extobj31;
	}

	public String getOpinion1() {
		return opinion1;
	}

	public void setOpinion1(String opinion1) {
		this.opinion1 = opinion1;
	}

	public DocExtClass getExtobj0() {
		return extobj0;
	}

	public void setExtobj0(DocExtClass extobj0) {
		this.extobj0 = extobj0;
	}
	
}
