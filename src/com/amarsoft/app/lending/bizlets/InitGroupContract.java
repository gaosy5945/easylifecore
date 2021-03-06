/*
 *	Author: jgao1 2009-10-22
 *	Tester:
 *	Describe: 集团授信额度生成集团成员的授信额度合同，及更新CL_INFO表
 *	Input Param: 			
 *	Output Param:			
 *	HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class InitGroupContract extends Bizlet{

	public Object  run(Transaction Sqlca) throws Exception{			
		//集团总授信额度合同编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//将空值转化为空字符串
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "";
		SqlObject so ;//声明对象
		ASResultSet rs = null;
		String gLine = "";//在集团授信Gline_INFO中的协议号
		String sLine = "";
		String iLine = "";//在CL_INFO中标志各集团成员额度协议号
		String sBBCSerialno = "";//集团各成员合同号		
		//在CL_INFO中取得集团授信额度主合同的协议号
		sSql = " select LineID from CL_INFO where BCSerialNo=:BCSerialNo order by LineID";
		so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo);
		sLine = Sqlca.getString(so);
		if(sLine == null) sLine = "";
		//在GLINE_INFO中取得集团成员额度协议号
		sSql = " select LineID from GLINE_INFO where BCSerialNo =:BCSerialNo and ParentLineID =:ParentLineID order by LineID";
		so = new SqlObject(sSql).setParameter("BCSerialNo", sObjectNo).setParameter("ParentLineID", sLine);
		rs=Sqlca.getASResultSet(so);
		while(rs.next()){
			gLine = rs.getString("LineID");
			if(gLine == null) gLine="";
			//先获得集团成员的合同号
			sBBCSerialno = AddContractInfo(sObjectNo,gLine,Sqlca);
			//获得集团成员的协议号
			iLine=AddCLInfo(gLine,sLine,Sqlca);
			UpdateCLInfo(sBBCSerialno,iLine,Sqlca);			
		}
		rs.getStatement().close();
	    return "true";	    
	 }
	
	/*
	 * 为每个集团成员在CL_INFO中新增记录。
	 */
	private String AddCLInfo(String gLine,String groupID,Transaction Sqlca) throws Exception{
		//groupID为集团授信额度的CL_INFO协议号
		if(groupID==null) groupID="";
		if(gLine==null) gLine="";
		String cLine="";
		cLine = DBKeyHelp.getSerialNo("CL_INFO","LineID",Sqlca);
		//此时插入为全部插入，还需要更新合同字段以及一些其他的字段保证正确！新生成的协议号中ParentLineID为空，为了扩展按业务品种时的方便以及匹配CL_INFO的逻辑
		String insertSql = " insert into CL_INFO(LINEID,CLTYPEID,CLTYPENAME,APPLYSERIALNO,APPROVESERIALNO,BCSERIALNO,LINECONTRACTNO,CUSTOMERID,CUSTOMERNAME,"+
	 					" LINESUM1,LINESUM2,LINESUM3,CURRENCY,LINEEFFDATE,LINEEFFFLAG,PUTOUTDEADLINE,MATURITYDEADLINE,ROTATIVE,APPROVALPOLICY,FREEZEFLAG,"+
	 					" RECENTCHECK,RECENTCHECKSTATUS,CHECKRESULT,OVERFLOWTYPE,INPUTUSER,INPUTORG,INPUTTIME,UPDATETIME,BEGINDATE,ENDDATE,"+
	 					" USEORGID,USEORGNAME,BAILRATIO,BUSINESSTYPE,USEDSUM,USABLESUM,CALCULATETIME,SUBBALANCE,GROUPLINEID)"+
	                    " select '"+cLine+"',CLTYPEID,getBusinessName('3020010') as CLTYPENAME,APPLYSERIALNO,APPROVESERIALNO,BCSERIALNO,LINECONTRACTNO,CUSTOMERID,CUSTOMERNAME,"+
	                    " LINESUM1,LINESUM2,LINESUM3,CURRENCY,LINEEFFDATE,LINEEFFFLAG,PUTOUTDEADLINE,MATURITYDEADLINE,ROTATIVE,APPROVALPOLICY,'1',"+
	                    " RECENTCHECK,RECENTCHECKSTATUS,CHECKRESULT,OVERFLOWTYPE,INPUTUSER,INPUTORG,INPUTTIME,UPDATETIME,BEGINDATE,ENDDATE,"+
	                    " USEORGID,USEORGNAME,BAILRATIO,BUSINESSTYPE,USEDSUM,USABLESUM,CALCULATETIME,SUBBALANCE,'"+groupID+"' "+
	                    " from GLINE_INFO "+
	                    " where LineID='"+gLine+"'";
		Sqlca.executeSQL(insertSql);
		return cLine;
	}
	
	 /*
	  * 更新CL_INFO的逻辑，与合同签署一致
	  */
	private void UpdateCLInfo(String bcSerialNo,String cLine,Transaction Sqlca) throws Exception{
		//成员合同号
		if(bcSerialNo==null) bcSerialNo="";
		//成员CL_INFO协议号
		if(cLine==null) cLine="";
		String updatesql = " update CL_INFO set(BCSerialNo,LineSum1,Currency,PutOutDeadLine,LineEffDate,BeginDate,EndDate,MaturityDeadLine,Rotative)= "+
		" (select SerialNo,BusinessSum,BusinessCurrency,LimitationTerm,BeginDate,PutOutDate,Maturity,UseTerm,CreditCycle "+
		" from BUSINESS_CONTRACT "+
		" where SerialNo=:SerialNo) "+
		" where LineID=:LineID";
	    SqlObject so  = new SqlObject(updatesql).setParameter("SerialNo", bcSerialNo).setParameter("LineID", cLine);
	    Sqlca.executeSQL(so);
	}
 
 	/*
 	 * 为每个集团成员新增集团额度合同
 	 */
 	private String AddContractInfo(String bcSerialNo,String gline,Transaction Sqlca) throws Exception{
 		//判断是否为空
 		if(bcSerialNo==null) bcSerialNo="";
 		if(gline==null) gline="";
 		//定义子合同流水号，客户编号，客户名称，币种，是否循环
 		String nSerialNo="",sCustomerID="",sCustomerName="",sCurrency="",sRotative="";
 		//定义集团成员授信限额，保证金比例
 		double dLineSum1=0.0,dBailratio=0.0;
 		ASResultSet rs=null;
 		//从集团成员授信额度GLINE_INFO表中取得每个客户的名称，授信限额等信息元素
 		String sSql = " select CustomerID,CustomerName,LineSum1,Currency,Rotative,Bailratio from GLINE_INFO where LineID=:LineID";
 		SqlObject so = new SqlObject(sSql).setParameter("LineID", gline);
 		rs=Sqlca.getASResultSet(so);
 		if(rs.next()){
 			//集团成员客户编号
 			sCustomerID=rs.getString("CustomerID");
 			sCustomerName=rs.getString("CustomerName");
 			//对应集团授信额度的BusinessSum
 			dLineSum1=rs.getDouble("LineSum1");
 			//对应集团授信额度的币种
 			sCurrency=rs.getString("Currency");
 			//是否可循环，对应合同的CREDITCYCLE
 			sRotative=rs.getString("Rotative");
 			dBailratio=rs.getDouble("Bailratio");
 		}
 		rs.getStatement().close();
 		if(sCustomerID==null) sCustomerID="";
 		if(sCustomerName==null) sCustomerName="";
 		if(sCurrency==null) sCurrency="";
 		if(sRotative==null) sRotative="";
 		//生成集团成员的合同号
 		nSerialNo = DBKeyHelp.getSerialNo("BUSINESS_CONTRACT","SerialNo",Sqlca);
 		//此时插入为全部插入，还需要更新合同字段以及一些其他的字段保证正确！GroupLineID为集团总额度合同号
 		String insertSql = " insert into BUSINESS_CONTRACT(SERIALNO,RELATIVESERIALNO,ARTIFICIALNO,OCCURDATE,CUSTOMERID,CUSTOMERNAME,BUSINESSTYPE,OLDBUSINESSTYPE,"+
	 					" BUSINESSSUBTYPE,OCCURTYPE,CREDITDIGEST,CREDITCYCLE,CREDITTYPE,CURRENYLIST,CURRENCYMODE,BUSINESSTYPELIST,CALCULATEMODE,USEORGLIST,"+
	 					" FLOWREDUCEFLAG,CONTRACTFLAG,SUBCONTRACTFLAG,SELFUSEFLAG,CREDITINDEX,CREDITREDUCESUM,LIMITATIONTERM,USETERM,CREDITAGGREEMENT,RELATIVEAGREEMENT,"+
	 					" LOANFLAG,TOTALSUM,OURROLE,REVERSIBILITY,BILLNUM,HOUSETYPE,LCTERMTYPE,RISKATTRIBUTE,SURETYPE,SAFEGUARDTYPE,CREDITBUSINESS,BUSINESSCURRENCY,BUSINESSSUM,"+
	 					" BUSINESSPROP,TERMYEAR,TERMMONTH,TERMDAY,LGTERM,BASERATETYPE,BASERATE,RATEFLOATTYPE,RATEFLOAT,BUSINESSRATE,ICTYPE,ICCYC,PDGRATIO,PDGSUM,PDGPAYMETHOD,"+
	 					" PDGPAYPERIOD,PROMISESFEERATIO,PROMISESFEESUM,PROMISESFEEPERIOD,PROMISESFEEBEGIN,MFEERATIO,MFEESUM,MFEEPAYMETHOD,AGENTFEE,DEALFEE,TOTALCAST,DISCOUNTINTEREST,"+
	 					" PURCHASERINTEREST,BARGAINORINTEREST,DISCOUNTSUM,BAILRATIO,BAILCURRENCY,BAILSUM,BAILACCOUNT,FINERATETYPE,FINERATE,DRAWINGTYPE,FIRSTDRAWINGDATE,"+
	 					" DRAWINGPERIOD,PAYTIMES,PAYCYC,GRACEPERIOD,OVERDRAFTPERIOD,OLDLCNO,OLDLCTERMTYPE,REMITMODE,OLDLCSUM,OLDLCLOADINGDATE,OLDLCVALIDDATE,DIRECTION,PURPOSE,"+
	 					" PLANALLOCATION,IMMEDIACYPAYSOURCE,PAYSOURCE,CORPUSPAYMETHOD,INTERESTPAYMETHOD,PUTOUTDATE,MATURITY,THIRDPARTY1,THIRDPARTYID1,THIRDPARTY2,THIRDPARTYID2,THIRDPARTY3,"+
	 					" THIRDPARTYID3,THIRDPARTYREGION,THIRDPARTYACCOUNTS,CARGOINFO,PROJECTNAME,OPERATIONINFO,CONTEXTINFO,SECURITIESTYPE,SECURITIESREGION,CONSTRUCTIONAREA,USEAREA,"+
	 					" FLAG1,FLAG2,FLAG3,TRADECONTRACTNO,INVOICENO,TRADECURRENCY,TRADESUM,LCNO,PAYMENTDATE,OPERATIONMODE,BEGINDATE,ENDDATE,VOUCHCLASS,VOUCHTYPE,VOUCHTYPE1,VOUCHTYPE2,"+
	 					" VOUCHFLAG,WARRANTOR,WARRANTORID,OTHERCONDITION,GUARANTYVALUE,GUARANTYRATE,BASEEVALUATERESULT,RISKRATE,LOWRISK,OTHERAREALOAN,LOWRISKBAILSUM,APPLYTYPE,"+
	 					" ORIGINALPUTOUTDATE,EXTENDTIMES,LNGOTIMES,GOLNTIMES,DRTIMES,GUARANTYNO,PUTOUTSUM,ACTUALPUTOUTSUM,BALANCE,NORMALBALANCE,OVERDUEBALANCE,DULLBALANCE,BADBALANCE,"+
	 					" INTERESTBALANCE1,INTERESTBALANCE2,FINEBALANCE1,FINEBALANCE2,OVERDUEDAYS,OWEINTERESTDAYS,TABALANCE,TAINTERESTBALANCE,TATIMES,LCATIMES,PBINTERESTSUM,PBMFEESUM,"+
	 					" PBPDGSUM,PBLEGALCOSTSUM,POLEGALCOSTSUM,ORIGINALBADDATE,BASECLASSIFYRESULT,CLASSIFYRESULT,CLASSIFYTYPE,CLASSIFYDATE,CLASSIFYORGID,RESERVESUM,EXPECTLOSSSUM,"+
	 					" BAILRATE,FINISHORG,FINISHTYPE,FINISHDATE,DESCRIBE1,REINFORCEFLAG,MANAGEORGID,MANAGEUSERID,RECOVERYORGID,RECOVERYUSERID,STATORGID,STATUSERID,OPERATEORGID,"+
	 					" OPERATEUSERID,OPERATEDATE,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,PIGEONHOLEDATE,REMARK,FLAG4,PAYCURRENCY,PAYDATE,FLAG5,CLASSIFYSUM1,CLASSIFYSUM2,"+
	 					" CLASSIFYSUM3,CLASSIFYSUM4,CLASSIFYSUM5,SHIFTTYPE,OPERATETYPE,FUNDSOURCE,CYCLEFLAG,CREDITFREEZEFLAG,SHIFTBALANCE,CLASSIFYFREQUENCY,CLASSIFYLEVEL,VOUCHNEWFLAG,"+
	 					" ACTUALARTIFICIALNO,DELETEFLAG,ACCOUNTNO,LOANACCOUNTNO,SECONDPAYACCOUNT,ADJUSTRATETYPE,ADJUSTRATETERM,OVERINTTYPE,RATEADJUSTCYC,PDGACCOUNTNO,DEDUCTDATE,"+
	 					" FZANBALANCE,ACCEPTINTTYPE,RATIO,THIRDPARTYADD1,THIRDPARTYZIP1,THIRDPARTYADD2,THIRDPARTYZIP2,THIRDPARTYADD3,THIRDPARTYZIP3,EFFECTAREA,TERMDATE1,TERMDATE2,"+
	 					" TERMDATE3,FIXCYC,DESCRIBE2,CANCELSUM,CANCELINTEREST,LOANTERM,PUTOUTORGID,TEMPSAVEFLAG,OVERDUEDATE,OWEINTERESTDATE,FREEZEFLAG,APPROVEDATE,SHIFTSTATUS,"+
	 					" RECOVERYCOGNORGID,RECOVERYCOGNUSERID,SHIFTDOCDESCRIBE,GUARANTYFLAG,TOTALBALANCE,GROUPLINEID) "+
	                    " select '"+nSerialNo+"',RELATIVESERIALNO,ARTIFICIALNO,OCCURDATE,'"+sCustomerID+"','"+sCustomerName+"','3020010' as BUSINESSTYPE,OLDBUSINESSTYPE,"+
	 					" BUSINESSSUBTYPE,OCCURTYPE,CREDITDIGEST,'"+sRotative+"',CREDITTYPE,CURRENYLIST,CURRENCYMODE,BUSINESSTYPELIST,CALCULATEMODE,USEORGLIST,"+
	 					" FLOWREDUCEFLAG,CONTRACTFLAG,SUBCONTRACTFLAG,SELFUSEFLAG,CREDITINDEX,CREDITREDUCESUM,LIMITATIONTERM,USETERM,CREDITAGGREEMENT,RELATIVEAGREEMENT,"+
	 					" LOANFLAG,TOTALSUM,OURROLE,REVERSIBILITY,BILLNUM,HOUSETYPE,LCTERMTYPE,RISKATTRIBUTE,SURETYPE,SAFEGUARDTYPE,CREDITBUSINESS,'"+sCurrency+"',"+dLineSum1+","+
	 					" BUSINESSPROP,TERMYEAR,TERMMONTH,TERMDAY,LGTERM,BASERATETYPE,BASERATE,RATEFLOATTYPE,RATEFLOAT,BUSINESSRATE,ICTYPE,ICCYC,PDGRATIO,PDGSUM,PDGPAYMETHOD,"+
	 					" PDGPAYPERIOD,PROMISESFEERATIO,PROMISESFEESUM,PROMISESFEEPERIOD,PROMISESFEEBEGIN,MFEERATIO,MFEESUM,MFEEPAYMETHOD,AGENTFEE,DEALFEE,TOTALCAST,DISCOUNTINTEREST,"+
	 					" PURCHASERINTEREST,BARGAINORINTEREST,DISCOUNTSUM,"+dBailratio+",BAILCURRENCY,BAILSUM,BAILACCOUNT,FINERATETYPE,FINERATE,DRAWINGTYPE,FIRSTDRAWINGDATE,"+
	 					" DRAWINGPERIOD,PAYTIMES,PAYCYC,GRACEPERIOD,OVERDRAFTPERIOD,OLDLCNO,OLDLCTERMTYPE,REMITMODE,OLDLCSUM,OLDLCLOADINGDATE,OLDLCVALIDDATE,DIRECTION,PURPOSE,"+
	 					" PLANALLOCATION,IMMEDIACYPAYSOURCE,PAYSOURCE,CORPUSPAYMETHOD,INTERESTPAYMETHOD,PUTOUTDATE,MATURITY,THIRDPARTY1,THIRDPARTYID1,THIRDPARTY2,THIRDPARTYID2,THIRDPARTY3,"+
	 					" THIRDPARTYID3,THIRDPARTYREGION,THIRDPARTYACCOUNTS,CARGOINFO,PROJECTNAME,OPERATIONINFO,CONTEXTINFO,SECURITIESTYPE,SECURITIESREGION,CONSTRUCTIONAREA,USEAREA,"+
	 					" FLAG1,FLAG2,FLAG3,TRADECONTRACTNO,INVOICENO,TRADECURRENCY,TRADESUM,LCNO,PAYMENTDATE,OPERATIONMODE,BEGINDATE,ENDDATE,VOUCHCLASS,VOUCHTYPE,VOUCHTYPE1,VOUCHTYPE2,"+
	 					" VOUCHFLAG,WARRANTOR,WARRANTORID,OTHERCONDITION,GUARANTYVALUE,GUARANTYRATE,BASEEVALUATERESULT,RISKRATE,LOWRISK,OTHERAREALOAN,LOWRISKBAILSUM,APPLYTYPE,"+
	 					" ORIGINALPUTOUTDATE,EXTENDTIMES,LNGOTIMES,GOLNTIMES,DRTIMES,GUARANTYNO,PUTOUTSUM,ACTUALPUTOUTSUM,BALANCE,NORMALBALANCE,OVERDUEBALANCE,DULLBALANCE,BADBALANCE,"+
	 					" INTERESTBALANCE1,INTERESTBALANCE2,FINEBALANCE1,FINEBALANCE2,OVERDUEDAYS,OWEINTERESTDAYS,TABALANCE,TAINTERESTBALANCE,TATIMES,LCATIMES,PBINTERESTSUM,PBMFEESUM,"+
	 					" PBPDGSUM,PBLEGALCOSTSUM,POLEGALCOSTSUM,ORIGINALBADDATE,BASECLASSIFYRESULT,CLASSIFYRESULT,CLASSIFYTYPE,CLASSIFYDATE,CLASSIFYORGID,RESERVESUM,EXPECTLOSSSUM,"+
	 					" BAILRATE,FINISHORG,FINISHTYPE,FINISHDATE,DESCRIBE1,REINFORCEFLAG,MANAGEORGID,MANAGEUSERID,RECOVERYORGID,RECOVERYUSERID,STATORGID,STATUSERID,OPERATEORGID,"+
	 					" OPERATEUSERID,OPERATEDATE,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,'"+StringFunction.getToday()+"',REMARK,FLAG4,PAYCURRENCY,PAYDATE,FLAG5,CLASSIFYSUM1,CLASSIFYSUM2,"+
	 					" CLASSIFYSUM3,CLASSIFYSUM4,CLASSIFYSUM5,SHIFTTYPE,OPERATETYPE,FUNDSOURCE,CYCLEFLAG,CREDITFREEZEFLAG,SHIFTBALANCE,CLASSIFYFREQUENCY,CLASSIFYLEVEL,VOUCHNEWFLAG,"+
	 					" ACTUALARTIFICIALNO,DELETEFLAG,ACCOUNTNO,LOANACCOUNTNO,SECONDPAYACCOUNT,ADJUSTRATETYPE,ADJUSTRATETERM,OVERINTTYPE,RATEADJUSTCYC,PDGACCOUNTNO,DEDUCTDATE,"+
	 					" FZANBALANCE,ACCEPTINTTYPE,RATIO,THIRDPARTYADD1,THIRDPARTYZIP1,THIRDPARTYADD2,THIRDPARTYZIP2,THIRDPARTYADD3,THIRDPARTYZIP3,EFFECTAREA,TERMDATE1,TERMDATE2,"+
	 					" TERMDATE3,FIXCYC,DESCRIBE2,CANCELSUM,CANCELINTEREST,LOANTERM,PUTOUTORGID,TEMPSAVEFLAG,OVERDUEDATE,OWEINTERESTDATE,FREEZEFLAG,APPROVEDATE,SHIFTSTATUS,"+
	 					" RECOVERYCOGNORGID,RECOVERYCOGNUSERID,SHIFTDOCDESCRIBE,GUARANTYFLAG,TOTALBALANCE,'"+bcSerialNo+"' "+
	                    " from BUSINESS_CONTRACT "+
	                    " where SerialNo='"+bcSerialNo+"'";
 		Sqlca.executeSQL(insertSql);
 		return nSerialNo;
 	}
}
