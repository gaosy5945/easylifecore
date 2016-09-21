package com.amarsoft.app.als.report.action;

import java.net.URLDecoder;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASDataObjectFilter;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author T-liuxt
 * 上海公积金报表，声明二位数组，将按逻辑取出的数进行赋值
 */

public class SHAccumulationReport extends ALSBusinessProcess implements BusinessObjectOWQuerier{
	
	private int totalCount = 8;
	
	public int query(BusinessObject inputParameters,ALSBusinessProcess businessProcess) throws Exception {
		return this.totalCount;
	}
	
	public BusinessObject[] getBusinessObjectList(int fromIndex, int toIndex) throws Exception {
		
		String month = null;
		String year = null;
		ASDataObject dataObject = this.getASDataObject();
		ASDataObjectFilter asFilter = (ASDataObjectFilter)dataObject.Filters.get(0);
		String colName = asFilter.acColumn.getAttribute("ColName");
		
		String sColFilterRefId = dataObject.getColumn(colName).getAttribute("COLFILTERREFID");
		if(sColFilterRefId!=null && sColFilterRefId.length()>0)
			colName = sColFilterRefId;
		String upperCaseColName = colName.toUpperCase();
		
		String businessDate;
		if(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_VALUE") != null){
			businessDate = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_VALUE").toString(),"UTF-8");
		}
		else
		{
			businessDate = DateHelper.getBusinessDate();
		}
		month = businessDate.substring(0, 7);
		year = businessDate.substring(0, 4);
		BizObjectClass bizClass = ObjectWindowHelper.getBizObjectClass(this.asDataObject);
		
		BusinessObject[] arr = new BusinessObject[8];
		String lastMonthDate = DateHelper.getEndDateOfMonth(DateHelper.getRelativeDate(businessDate, DateHelper.TERM_UNIT_MONTH, -1));
		String lastYearDate = DateHelper.getEndDateOfMonth(DateHelper.getRelativeDate(businessDate, DateHelper.TERM_UNIT_YEAR, -1));
		String orgID = "9800";
		Configure CurConfig = Configure.getInstance();
		String sDataSource = CurConfig.getConfigure("DataSource");
		Transaction Sqlca = new Transaction(sDataSource);
		double lastMonthBalance =DataConvert.toDouble(Sqlca.getString(new SqlObject("select balance from FUND_USE where OrgID=:OrgID and OccurDate =:OccurDate").setParameter("OccurDate", lastMonthDate).setParameter("OrgID", orgID)));
		double lastBalanceYear =DataConvert.toDouble(Sqlca.getString(new SqlObject("select balance from FUND_USE where OrgID=:OrgID and OccurDate =:OccurDate").setParameter("OccurDate", lastYearDate).setParameter("OrgID", orgID)));
		arr[0] = BusinessObject.createBusinessObject(bizClass);
		arr[0].setAttributeValue("Catalog", "上期结存基金");
		arr[0].setAttributeValue("Months", lastMonthBalance);
		arr[0].setAttributeValue("Years", 0.0);
		
		double btocMonthAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction and OccurDate<=:CurDate").setParameter("CurMonth", month+"%").setParameter("Direction", "4").setParameter("OrgID", orgID).setParameter("CurDate", businessDate)));
		double btocYearAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurYear and Direction=:Direction and OccurDate<=:CurDate").setParameter("CurYear", year+"%").setParameter("Direction", "4").setParameter("OrgID", orgID).setParameter("CurDate", businessDate)));
		arr[1] = BusinessObject.createBusinessObject(bizClass);
		arr[1].setAttributeValue("Catalog", "已划市中心基金");
		arr[1].setAttributeValue("Months", btocMonthAmt);
		arr[1].setAttributeValue("Years", btocYearAmt);
		
		double ctobMonthAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction and OccurDate<=:CurDate").setParameter("CurMonth", month+"%").setParameter("Direction", "3").setParameter("OrgID", orgID).setParameter("CurDate", businessDate)));
		double ctobYearAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurYear and Direction=:Direction and OccurDate<=:CurDate").setParameter("CurYear", year+"%").setParameter("Direction", "3").setParameter("OrgID", orgID).setParameter("CurDate", businessDate)));
		arr[2] = BusinessObject.createBusinessObject(bizClass);
		arr[2].setAttributeValue("Catalog", "实际收到基金");
		arr[2].setAttributeValue("Months", ctobMonthAmt);
		arr[2].setAttributeValue("Years", ctobYearAmt);
		
		String MonthUsers = DataConvert.toString(Sqlca.getString(new SqlObject("select count(SerialNo) from BUSINESS_DUEBILL where BusinessType in('100','101','102') and MFOrgID in (select BelongOrgID from ORG_BELONG where OrgID=:OrgID) and BusinessStatus in ('L0','L11','L12','L13','L2') and PutoutDate like :PurtoutDate and PutoutDate<=:CurDate").setParameter("OrgID", orgID).setParameter("PurtoutDate", month+"%").setParameter("CurDate", businessDate)));
		String YearUsers = DataConvert.toString(Sqlca.getString(new SqlObject("select count(SerialNo) from BUSINESS_DUEBILL where BusinessType in('100','101','102') and MFOrgID in (select BelongOrgID from ORG_BELONG where OrgID=:OrgID) and BusinessStatus in ('L0','L11','L12','L13','L2') and PutoutDate like :PurtoutDate and PutoutDate<=:CurDate").setParameter("OrgID", orgID).setParameter("PurtoutDate", year+"%").setParameter("CurDate", businessDate)));
		arr[3] = BusinessObject.createBusinessObject(bizClass);
		arr[3].setAttributeValue("Catalog", "户数");
		arr[3].setAttributeValue("Months", MonthUsers);
		arr[3].setAttributeValue("Years", YearUsers);
		
		double LoanMonthSum = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(BDMain.BusinessSum) from BUSINESS_DUEBILL BDMain where BDMain.ContractSerialNo in (select CR.ContractSerialNo from BUSINESS_DUEBILL BD, CONTRACT_RELATIVE CR where CR.ObjectType = 'jbo.app.BUSINESS_CONTRACT' and CR.ObjectNo = BD.ContractSerialNo and CR.RelativeType = '07' and BD.BusinessType in ('100', '101', '102') and BD.BusinessStatus in ('L0','L11','L12','L13','L2') and BD.MFOrgID in (select BelongOrgID from ORG_BELONG where OrgID=:OrgID) and BD.PutoutDate like :PutoutDate  and BD.PutoutDate<=:CurDate) and BDMain.BusinessStatus in ('L0','L11','L12','L13','L2')").setParameter("OrgID", orgID).setParameter("PutoutDate", month+"%").setParameter("CurDate", businessDate)));
		double LoanYearSum = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(BDMain.BusinessSum) from BUSINESS_DUEBILL BDMain where BDMain.ContractSerialNo in (select CR.ContractSerialNo from BUSINESS_DUEBILL BD, CONTRACT_RELATIVE CR where CR.ObjectType = 'jbo.app.BUSINESS_CONTRACT' and CR.ObjectNo = BD.ContractSerialNo and CR.RelativeType = '07' and BD.BusinessType in ('100', '101', '102') and BD.BusinessStatus in ('L0','L11','L12','L13','L2') and BD.MFOrgID in (select BelongOrgID from ORG_BELONG where OrgID=:OrgID) and BD.PutoutDate like :PutoutDate  and BD.PutoutDate<=:CurDate) and BDMain.BusinessStatus in ('L0','L11','L12','L13','L2')").setParameter("OrgID", orgID).setParameter("PutoutDate", year+"%").setParameter("CurDate", businessDate)));
		arr[4] = BusinessObject.createBusinessObject(bizClass);
		arr[4].setAttributeValue("Catalog", "按揭贷款金额");
		arr[4].setAttributeValue("Months", LoanMonthSum);
		arr[4].setAttributeValue("Years", LoanYearSum);

		double FundLoanMonthSum = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(BusinessSum) from BUSINESS_DUEBILL where BusinessType in('100','101','102') and MFOrgID in (select BelongOrgID from ORG_BELONG where OrgID=:OrgID) and BusinessStatus in ('L0','L11','L12','L13','L2') and PutoutDate like :PurtoutDate and PutoutDate<=:CurDate").setParameter("OrgID", orgID).setParameter("PurtoutDate", month+"%").setParameter("CurDate", businessDate)));
		double FundLoanYearSum = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(BusinessSum) from BUSINESS_DUEBILL where BusinessType in('100','101','102') and MFOrgID in (select BelongOrgID from ORG_BELONG where OrgID=:OrgID) and BusinessStatus in ('L0','L11','L12','L13','L2') and PutoutDate like :PurtoutDate and PutoutDate<=:CurDate").setParameter("OrgID", orgID).setParameter("PurtoutDate", year+"%").setParameter("CurDate", businessDate)));
		arr[5] = BusinessObject.createBusinessObject(bizClass);
		arr[5].setAttributeValue("Catalog", "公积金贷款金额");
		arr[5].setAttributeValue("Months", FundLoanMonthSum);
		arr[5].setAttributeValue("Years", FundLoanYearSum);
		
		double btosbMonthAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction and OccurDate<=:CurDate").setParameter("CurMonth", month+"%").setParameter("Direction", "1").setParameter("OrgID", orgID).setParameter("CurDate", businessDate)));
		double btosbYearAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurYear and Direction=:Direction and OccurDate<=:CurDate").setParameter("CurYear", year+"%").setParameter("Direction", "1").setParameter("OrgID", orgID).setParameter("CurDate", businessDate)));
		
		double sbtobMonthAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurMonth and Direction=:Direction and OccurDate<=:CurDate").setParameter("CurMonth", month+"%").setParameter("Direction", "2").setParameter("OrgID", orgID).setParameter("CurDate", businessDate)));
		double sbtobYearAmt = DataConvert.toDouble(Sqlca.getString(new SqlObject("select sum(nvl(Amount,0)) from FUND_TRANSFER where (OrgID=:OrgID or subOrgID=:OrgID) and OccurDate like :CurYear and Direction=:Direction and OccurDate<=:CurDate").setParameter("CurYear", year+"%").setParameter("Direction", "2").setParameter("OrgID", orgID).setParameter("CurDate", businessDate)));
		arr[6] = BusinessObject.createBusinessObject(bizClass);
		arr[6].setAttributeValue("Catalog", "实际使用基金");
		arr[6].setAttributeValue("Months", btosbMonthAmt-sbtobMonthAmt);
		arr[6].setAttributeValue("Years", btosbYearAmt-sbtobYearAmt);
		arr[7] = BusinessObject.createBusinessObject(bizClass);
		arr[7].setAttributeValue("Catalog", "期末结存基金");
		arr[7].setAttributeValue("Months", lastMonthBalance+ctobMonthAmt-btocMonthAmt-btosbMonthAmt+sbtobMonthAmt);
		arr[7].setAttributeValue("Years", lastMonthBalance+ctobMonthAmt-btocMonthAmt-btosbMonthAmt+sbtobMonthAmt);
		return arr;
	}

	public int getTotalCount() throws Exception {
		return totalCount;
	}
}
