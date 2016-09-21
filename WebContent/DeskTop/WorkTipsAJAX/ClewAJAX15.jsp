<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;

	String sBeginDate=StringFunction.getToday();
	String sEndDate = StringFunction.getRelativeDate(StringFunction.getToday(),15);
	
	WhereCase=	" from BUSINESS_DUEBILL "+
				" where Maturity >= ' "+sBeginDate+
				" ' and  Maturity<= ' "+sEndDate+
				" ' and OperateUserID=:UserID "+
				" and (FinishDate is null "+
				" or FinishDate = ' ') ";
	
	if(sFlag.equals("0")){
		sSql = 	" select count(SerialNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql= " select '&nbsp;['||getBusinessName(BusinessType)||']'||'&nbsp;['||CustomerName||']'||'&nbsp;['||Maturity||']', "+
				  "Balance ";
		sSql = sSql+ WhereCase ;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		while(rsTips.next()){
				sTipsFlag="<img src='"+sWebRootPath+"/DeskTop/WorkTipsAJAX/icon_alert.gif' width=12 height=12 >&nbsp;";
		%>
                      	<tr>
                      	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('MatureLoanAlertList','/CreditManage/CreditAlarm/MatureLoanAlertList.jsp','Days=15','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                     		<td align="right" valign="bottom"><%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                     	<br></tr>
		<%
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>