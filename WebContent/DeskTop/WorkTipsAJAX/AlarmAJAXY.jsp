<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	
	String sClewDate = StringFunction.getRelativeDate(StringFunction.getToday(),7);
	
	WhereCase=" from RISK_SIGNAL RS "+
			" where RS.ObjectType = 'Customer' "+
			" and RS.SignalType = '01' "+ 
			" and RS.SignalStatus = '30' "+
			" and ((exists (select RO.ObjectNo from RISKSIGNAL_OPINION RO "+
			" where RO.ObjectNo = RS.SerialNo "+
			" and RO.NextCheckDate <= '"+sClewDate+"' "+
			" and RO.NextCheckUser = '"+CurUser.getUserID()+"'))) "+
			 " and (FinishDate is not null and FinishDate <> ' ') ";
	
	if(sFlag.equals("0")){
		sSql = 	" select count(RS.ObjectNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql));
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql= " select '&nbsp;['||GetCustomerName(RS.ObjectNo)||']'||'&nbsp;['||RS.SignalName||']'||'&nbsp;['||getItemName('SignalType',RS.SignalType)||']'";
		sSql = sSql+ WhereCase ;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql));
		while(rsTips.next()){
				sTipsFlag="<img src='"+sWebRootPath+"/DeskTop/WorkTipsAJAX/icon_alert.gif' width=12 height=12 >&nbsp;";
		%>javascript:parent.OpenComp("RiskSignalCheckList","/CreditManage/CreditAlarm/RiskSignalCheckList.jsp","FinishType=N","right","") 
                      	<tr>
                      	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('RiskSignalCheckList','/CreditManage/CreditAlarm/RiskSignalCheckList.jsp','FinishType=Y','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                     	<br></tr>
		<%
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>