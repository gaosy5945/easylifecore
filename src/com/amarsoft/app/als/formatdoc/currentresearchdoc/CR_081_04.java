package com.amarsoft.app.als.formatdoc.currentresearchdoc;

import java.io.FileInputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.amarsoft.app.als.finance.analyse.model.CustomerFSRecord;
import com.amarsoft.app.als.finance.analyse.model.FinanceDataManager;
import com.amarsoft.app.als.finance.analyse.model.FinanceDetailManager;
import com.amarsoft.app.als.finance.analyse.model.FinanceDetailRcv;
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

public class CR_081_04 extends FormatDocData implements Serializable {
	private static final long serialVersionUID = 1L;

	private DocExtClass extobj1;
	private DocExtClass extobj2;
	private DocExtClass extobj3;
	private DocExtClass extobj4;
	private DocExtClass extobj5;
	private DocExtClass extobj6;
	private DocExtClass extobj7[];
	private DocExtClass extobj8;
	private DocExtClass extobj9;
	private DocExtClass extobj10;
	private DocExtClass extobj11;
	private DocExtClass extobj12;
	private DocExtClass extobj13[];
	
	private String opinion1="";
	private String opinion2="";
	private String opinion3="";
	private String opinion4="";
	private String opinion5="";
	String customerID = "";
	String sFinancelType="";
	public CR_081_04() {
	}

	public boolean initObjectForRead() {
		
		String sObjectNo=this.getRecordObjectNo();
		if(sObjectNo==null)sObjectNo="";
		String guarantyNo = this.getGuarantyNo();	
		if(guarantyNo==null)guarantyNo="";
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		
		String sCustomerID = "";
	
		try {
			if(guarantyNo!=null&& !"".equals(guarantyNo)){
				m = JBOFactory.getFactory().getManager(GuarantyConst.GUARANTY_INFO);
				q = m.createQuery("GuarantyID=:GuarantyID").setParameter("GuarantyID", guarantyNo);
				bo = q.getSingleResult();
				if(bo != null){
					sCustomerID = bo.getAttribute("COLASSETOWNER").getString();
				}
			}
			if(sCustomerID!=null&& !"".equals(sCustomerID)){
				sFinancelType = getReportType(sCustomerID);
				
				if(sFinancelType.equals("010")||sFinancelType.equals("020")){
					FinanceDataManager financedata = new FinanceDataManager();
					CustomerFSRecord cfs = financedata.getNewestReport(sCustomerID);
					CustomerFSRecord cfs1 = null;
					String reportNo = "";
					String laReportNo = "";
					Map reportMap = null;
					if(cfs != null){
						reportNo = financedata.getDetailNo(cfs);
						cfs1 = financedata.getRelativeYearReport(cfs,-1);
						reportMap = financedata.getAssetIDMap(cfs);
					}
					if(cfs1!=null){
						laReportNo = financedata.getDetailNo(cfs1);
					}
					FinanceDetailManager fdm = new FinanceDetailManager();
					//应付票据
					extobj1 = new DocExtClass();
					m = JBOFactory.getFactory().getManager("jbo.finasys.NOTES_PAYABLE");
					q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='01'").setParameter("sREPORTNO",reportNo);
					bo = q.getSingleResult();
					double ych = 0,laych=0,sch=0,lasch=0;
					if(bo != null){
						ych = bo.getAttribute("amount1").getDouble();
						extobj1.setAttr1(DataConvert.toMoney(ych));
					}
					q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='01'").setParameter("sREPORTNO",laReportNo);
					bo = q.getSingleResult();
					if(bo != null){
						laych = bo.getAttribute("amount1").getDouble();
						extobj1.setAttr2(DataConvert.toMoney(laych));
					}
					q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='02'").setParameter("sREPORTNO",reportNo);
					bo = q.getSingleResult();
					if(bo != null){
						sch = bo.getAttribute("amount1").getDouble();
						extobj1.setAttr4(DataConvert.toMoney(sch));
					}
					q = m.createQuery("select sum(AMOUNT) as V.amount1 from O where O.REPORTNO=:sREPORTNO and O.NOTETYPE='02'").setParameter("sREPORTNO",laReportNo);
					bo = q.getSingleResult();
					if(bo != null){
						lasch = bo.getAttribute("amount1").getDouble();
						extobj1.setAttr5(DataConvert.toMoney(lasch));
					}
					extobj1.setAttr3(DataConvert.toMoney(ych-laych));
					extobj1.setAttr6(DataConvert.toMoney(sch-lasch));
					extobj1.setAttr7(DataConvert.toMoney(ych+sch));
					extobj1.setAttr8(DataConvert.toMoney(laych+lasch));
					extobj1.setAttr9(DataConvert.toMoney(ych-laych+sch-lasch));
					ReportSubject rs = null;
					double yfzk = 0;
					double qtyfzk = 0;
					if(reportMap.size()>0){
						rs = (ReportSubject) reportMap.get("206");
						yfzk = rs.getCol2Value();
						rs = (ReportSubject) reportMap.get("218");
						qtyfzk = rs.getCol2Value();
					}
					List<FinanceDetailRcv> rcvList1 = fdm.getDetailData(cfs, "应付帐款");
					double tmin = 0;
					double tmout = 0;
					double tyin = 0;
					double tyout = 0;
					double alls =0;
					extobj2 = new DocExtClass();
					extobj3 = new DocExtClass();
					extobj4 = new DocExtClass();
					extobj5 = new DocExtClass();
					extobj6 = new DocExtClass();
					
					extobj8 = new DocExtClass();
					extobj9 = new DocExtClass();
					extobj10 = new DocExtClass();
					extobj11 = new DocExtClass();
					extobj12 = new DocExtClass();
					if(rcvList1.size()>0){
						for(int i=0;i<rcvList1.size();i++){
							FinanceDetailRcv rece = rcvList1.get(i);
							if("3个月以内（含）".equals(rece.getDataType())){
								tmin = tmin + rece.getAmount();
							}else if("3个月~1年（含）".equals(rece.getDataType())){
								tmout = tmout + rece.getAmount();
							}else if("1~3年（含）".equals(rece.getDataType())){
								tyin = tyin + rece.getAmount();
							}else if("3年以上".equals(rece.getDataType())){
								tyout = tyout + rece.getAmount();
							}
						}
						alls = tmin + tmout + tyout + tyin;
						extobj2.setAttr1(DataConvert.toMoney(tmin));
						extobj3.setAttr1(DataConvert.toMoney(tmout));
						extobj4.setAttr1(DataConvert.toMoney(tyin));
						extobj5.setAttr1(DataConvert.toMoney(tyout));
						extobj6.setAttr1(DataConvert.toMoney(alls));
						if(yfzk==0){
							extobj2.setAttr4("0");
							extobj3.setAttr4("0");
							extobj4.setAttr4("0");
							extobj5.setAttr4("0");
						}else{
							extobj2.setAttr4(String.format("%.0f",(tmin/yfzk)*100));
							extobj3.setAttr4(String.format("%.0f",(tmout/yfzk)*100));
							extobj4.setAttr4(String.format("%.0f",(tyin/yfzk)*100));
							extobj5.setAttr4(String.format("%.0f",(tyout/yfzk)*100));
						}
					}
					
					List<FinanceDetailRcv> rcvList2 = fdm.getDetailData(cfs1, "应付帐款");
					double latmin = 0;
					double latmout = 0;
					double latyin = 0;
					double latyout = 0;
					double laalls =0;
					if(rcvList2.size()>0){
						for(int i=0;i<rcvList2.size();i++){
							FinanceDetailRcv rece = rcvList2.get(i);
							if("3个月以内（含）".equals(rece.getDataType())){
								latmin = latmin + rece.getAmount();
							}else if("3个月~1年（含）".equals(rece.getDataType())){
								latmout = latmout + rece.getAmount();
							}else if("1~3年（含）".equals(rece.getDataType())){
								latyin = latyin + rece.getAmount();
							}else if("3年以上".equals(rece.getDataType())){
								latyout = latyout + rece.getAmount();
							}
						}
						laalls = latmin + latmout + latyout + latyin;
						extobj2.setAttr2(DataConvert.toMoney(latmin));
						extobj2.setAttr3(DataConvert.toMoney(tmin-latmin));
						extobj3.setAttr2(DataConvert.toMoney(latmout));
						extobj3.setAttr3(DataConvert.toMoney(tmout-latmout));
						extobj4.setAttr2(DataConvert.toMoney(latyin));
						extobj4.setAttr3(DataConvert.toMoney(tyin-latyin));
						extobj5.setAttr2(DataConvert.toMoney(latyout));
						extobj5.setAttr3(DataConvert.toMoney(tyout-latyout));
						extobj6.setAttr2(DataConvert.toMoney(laalls));
						extobj6.setAttr3(DataConvert.toMoney(alls-laalls));
					}
					
					List<FinanceDetailRcv> rcvList3 = fdm.getDetailData(cfs, "其他应付帐款");
					double tmin1 = 0;
					double tmout1 = 0;
					double tyin1 = 0;
					double tyout1 = 0;
					double alls1 =0;
					if(rcvList3.size()>0){
						for(int i=0;i<rcvList3.size();i++){
							FinanceDetailRcv rece = rcvList3.get(i);
							if("3个月以内（含）".equals(rece.getDataType())){
								tmin1 = tmin1 + rece.getAmount();
							}else if("3个月~1年（含）".equals(rece.getDataType())){
								tmout1 = tmout1 + rece.getAmount();
							}else if("1~3年（含）".equals(rece.getDataType())){
								tyin1 = tyin1 + rece.getAmount();
							}else if("3年以上".equals(rece.getDataType())){
								tyout1 = tyout1 + rece.getAmount();
							}
						}
						alls1 = tmin1 + tmout1 + tyout1 + tyin1;
						extobj8.setAttr1(DataConvert.toMoney(tmin1));
						extobj9.setAttr1(DataConvert.toMoney(tmout1));
						extobj10.setAttr1(DataConvert.toMoney(tyin1));
						extobj11.setAttr1(DataConvert.toMoney(tyout1));
						extobj12.setAttr1(DataConvert.toMoney(alls1));
						if(qtyfzk==0){
							extobj8.setAttr4("0");
							extobj9.setAttr4("0");
							extobj10.setAttr4("0");
							extobj11.setAttr4("0");
						}else{
							extobj8.setAttr4(String.format("%.0f",(tmin1/qtyfzk)*100));
							extobj9.setAttr4(String.format("%.0f",(tmout1/qtyfzk)*100));
							extobj10.setAttr4(String.format("%.0f",(tyin1/qtyfzk)*100));
							extobj11.setAttr4(String.format("%.0f",(tyout1/qtyfzk)*100));
						}
					}
					
					List<FinanceDetailRcv> rcvList4 = fdm.getDetailData(cfs1, "其他应付帐款");
					double latmin1 = 0;
					double latmout1 = 0;
					double latyin1 = 0;
					double latyout1 = 0;
					double laalls1 =0;
					if(rcvList4.size()>0){
						for(int i=0;i<rcvList4.size();i++){
							FinanceDetailRcv rece = rcvList4.get(i);
							if("3个月以内（含）".equals(rece.getDataType())){
								latmin1 = latmin1 + rece.getAmount();
							}else if("3个月~1年（含）".equals(rece.getDataType())){
								latmout1 = latmout1 + rece.getAmount();
							}else if("1~3年（含）".equals(rece.getDataType())){
								latyin1 = latyin1 + rece.getAmount();
							}else if("3年以上".equals(rece.getDataType())){
								latyout1 = latyout1 + rece.getAmount();
							}
						}
						laalls1 = latmin1 + latmout1 + latyout1 + latyin1;
						extobj8.setAttr2(DataConvert.toMoney(latmin1));
						extobj8.setAttr3(DataConvert.toMoney(tmin1-latmin1));
						extobj9.setAttr2(DataConvert.toMoney(latmout1));
						extobj9.setAttr3(DataConvert.toMoney(tmout1-latmout1));
						extobj10.setAttr2(DataConvert.toMoney(latyin1));
						extobj10.setAttr3(DataConvert.toMoney(tyin1-latyin1));
						extobj11.setAttr2(DataConvert.toMoney(latyout1));
						extobj11.setAttr3(DataConvert.toMoney(tyout1-latyout1));
						extobj12.setAttr2(DataConvert.toMoney(laalls1));
						extobj12.setAttr3(DataConvert.toMoney(alls1-laalls1));
					}
					//应付账款
					m = JBOFactory.getFactory().getManager("jbo.finasys.DETAIL_PAYABLE");
					q = m.createQuery("REPORTNO=:REPORTNO AND PAYTYPE='01'").setParameter("REPORTNO",reportNo);
					List<BizObject> payables = q.getResultList();
					extobj7 = new DocExtClass[payables.size()];
					if(payables.size()>5){
						extobj7 = new DocExtClass[5];
						for(int i=0;i<5;i++){
							BizObject payable = payables.get(i);
							extobj7[i] = new DocExtClass();
							extobj7[i].setAttr1(payable.getAttribute("CORPNAME").getString());
							String currency = payable.getAttribute("CURRENCY").getString();
							extobj7[i].setAttr2(CodeManager.getItemName("Currency", currency));
							extobj7[i].setAttr3(DataConvert.toMoney(payable.getAttribute("AMOUNT").getDouble()));
							String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
							extobj7[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
							String law = payable.getAttribute("LAWSUIT").getString();
							extobj7[i].setAttr5(CodeManager.getItemName("YesNo", law));
							String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
							extobj7[i].setAttr6(CodeManager.getItemName("FootType", accountType));
							String isRelative = payable.getAttribute("ISRELATIVE").getString();
							extobj7[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
						}
					}else if(payables.size()<=5){
//					extobj7 = new DocExtClass[payables.size()];
						for(int i=0;i<payables.size();i++){
							BizObject payable = payables.get(i);
							extobj7[i] = new DocExtClass();
							extobj7[i].setAttr1(payable.getAttribute("CORPNAME").getString());
							String currency = payable.getAttribute("CURRENCY").getString();
							extobj7[i].setAttr2(CodeManager.getItemName("Currency", currency));
							extobj7[i].setAttr3(DataConvert.toMoney(payable.getAttribute("AMOUNT").getDouble()));
							String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
							extobj7[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
							String law = payable.getAttribute("LAWSUIT").getString();
							extobj7[i].setAttr5(CodeManager.getItemName("YesNo", law));
							String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
							extobj7[i].setAttr6(CodeManager.getItemName("FootType", accountType));
							String isRelative = payable.getAttribute("ISRELATIVE").getString();
							extobj7[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
						}
					}
					//其他应付账款
					q = m.createQuery("REPORTNO=:REPORTNO AND PAYTYPE='02'").setParameter("REPORTNO",reportNo);
					payables = q.getResultList();
					extobj13 = new DocExtClass[payables.size()];
					if(payables.size()>5){
						extobj13 = new DocExtClass[5];
						for(int i=0;i<5;i++){
							BizObject payable = payables.get(i);
							extobj13[i] = new DocExtClass();
							extobj13[i].setAttr1(payable.getAttribute("CORPNAME").getString());
							String currency = payable.getAttribute("CURRENCY").getString();
							extobj13[i].setAttr2(CodeManager.getItemName("Currency", currency));
							extobj13[i].setAttr3(DataConvert.toMoney(payable.getAttribute("AMOUNT").getDouble()));
							String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
							extobj13[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
							String law = payable.getAttribute("LAWSUIT").getString();
							extobj13[i].setAttr5(CodeManager.getItemName("YesNo", law));
							String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
							extobj13[i].setAttr6(CodeManager.getItemName("FootType", accountType));
							String isRelative = payable.getAttribute("ISRELATIVE").getString();
							extobj13[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
						}
					}else if(payables.size()<=5){
//					extobj13 = new DocExtClass[payables.size()];
						for(int i=0;i<payables.size();i++){
							BizObject payable = payables.get(i);
							extobj13[i] = new DocExtClass();
							extobj13[i].setAttr1(payable.getAttribute("CORPNAME").getString());
							String currency = payable.getAttribute("CURRENCY").getString();
							extobj13[i].setAttr2(CodeManager.getItemName("Currency", currency));
							extobj13[i].setAttr3(DataConvert.toMoney(payable.getAttribute("AMOUNT").getDouble()));
							String accountAge = payable.getAttribute("ACCOUNTAGE").getString();
							extobj13[i].setAttr4(CodeManager.getItemName("AccountAge", accountAge));
							String law = payable.getAttribute("LAWSUIT").getString();
							extobj13[i].setAttr5(CodeManager.getItemName("YesNo", law));
							String accountType = payable.getAttribute("ACCOUNTTYPE").getString();
							extobj13[i].setAttr6(CodeManager.getItemName("FootType", accountType));
							String isRelative = payable.getAttribute("ISRELATIVE").getString();
							extobj13[i].setAttr7(CodeManager.getItemName("YesNo", isRelative));
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

	public void setModelInputStream()throws Exception{
		try{
			if(sFinancelType.equals("010")){//新会计准则
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_04.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_04.html");
			}else if(sFinancelType.equals("020")){//旧会计准则
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/CurrentResearchDoc/CR_081_04.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/CurrentResearchDoc/CR_081_04.html");
			}else {//if(sFinancelType.equals("300")){//财务简表
				ARE.getLog().trace(this.config.getPhysicalRootPath()+ "/FormatDoc/Blank_000.html");
				this.modelInStream = new FileInputStream(this.config.getPhysicalRootPath() + "/FormatDoc/Blank_000.html");
			}
		}
		catch(Exception e){
			throw new Exception("没有找到模板文件：" + e.toString());
		}
	}
	
	//获取报表类型 
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

	public DocExtClass[] getExtobj7() {
		return extobj7;
	}

	public void setExtobj7(DocExtClass[] extobj7) {
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

	public DocExtClass[] getExtobj13() {
		return extobj13;
	}

	public void setExtobj13(DocExtClass[] extobj13) {
		this.extobj13 = extobj13;
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
	
}

