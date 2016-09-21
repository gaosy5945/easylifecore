<%@page import="com.amarsoft.app.als.sys.org.OrgConfig"%><%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%>

<META HTTP-EQUIV="expires" CONTENT="-1">
<%	String serialNo = CurPage.getParameter("SerialNo");	if(serialNo == null)	serialNo = "";	 	String occurDate = "",subOrgID = "",subOrgName="",reAcctNo = "";	double amount=0d;	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select OccurDate,SubOrgID,sum(Amount) as Amount,count(*) as cnt from fund_transfer where SerialNo in('"+serialNo.replaceAll(",", "','")+"') group by OccurDate,SubOrgID order by OccurDate,SubOrgID"));		int i = 0;
	//for (int i = 0; i < list.size(); i++) {	while(rs.next())	{			occurDate = rs.getString("OccurDate");			subOrgID = rs.getString("SubOrgID");			amount = rs.getDouble("Amount");			int cnt = rs.getInt("cnt");						String YEAR = occurDate.substring(0,4);//年			String MONTH = occurDate.substring(5, 7);//月			String DATE = occurDate.substring(8, 10);//日						BusinessObject org = OrgConfig.getOrg(subOrgID);					double height1 = 0.0d;					double height2 = 0.0d;							char[] moneys = new char[11];			
			height1 = (75.17)*i*2;
			height2 = height1 + 75;

           	Map map = new HashMap();
           	map.put("YEAR",YEAR);
           	map.put("MONTH",MONTH);
           	map.put("DATE",DATE);
           	map.put("ACTNO",org.getString("FUNDACCTNO"));
           	map.put("CAPITAL",StringFunction.numberToChinese(amount));           	           	map.put("DIGITAL",DataConvert.toMoney(amount));
           	map.put("BRCODE",org.getString("OrgID")+"-"+org.getString("OrgName"));
           	map.put("COUNT",cnt);

            map.put("BRNAME_BRCODE", org.getString("OrgName")+ " " +org.getString("OrgID"));

            //转换小写数据。
            String digital = (String)map.get("DIGITAL");


            for (int j=0; j<moneys.length; j++ ){
            	moneys[j] = ' ';
            }
            digital = digital.replaceAll("[,.]","");
            char[] digitals = digital.toCharArray();			int j=0;
            for ( j=0; j<digitals.length; j++ ){
            	if ( moneys.length-j-1 < 0 )break;
				moneys[moneys.length-j-1] = digitals[digitals.length-j-1];
            }

            if ( moneys.length - j - 1 >= 0 ){
            	moneys[moneys.length-j-1] = '￥';
            }

%>
	<!--借方传票****************************-->
	<!--年份-->
  	<DIV id="div1" STYLE="position: absolute; top: <%=height1+14%>mm; left: 86mm; font: 9pt 楷体;"><%=map.get("YEAR")%></DIV>
  	<!--月份-->
  	<DIV STYLE="position: absolute; top: <%=height1+14%>mm; left: 100mm; font: 9pt 楷体;"><%=map.get("MONTH")%></DIV>
  	<!--日期-->
  	<DIV STYLE="position: absolute; top: <%=height1+14%>mm; left: 112mm; font: 9pt 楷体;"><%=map.get("DATE")%></DIV>
  	<!--付款单位全称-->
  	<DIV STYLE="position: absolute; top: <%=height1+19.5%>mm; left: 50mm; width: 40mm; font: 9pt 楷体;">上海市公积金管理中心个贷基金(浦发)专户 </DIV>
  	<!--收款单位全称-->
  	<DIV STYLE="position: absolute; top: <%=height1+19.5%>mm; left: 128mm; font: 9pt 楷体;">待划转代理公积金贷款 </DIV>
  	<!--付款单位帐号-->
	<DIV STYLE="position: absolute; top: <%=height1+28%>mm; left: 53mm; width: 40mm; font: 9pt 楷体;">0764024291025721</DIV>
  	<!--收款单位帐号-->
  	<DIV STYLE="position: absolute; top: <%=height1+28%>mm; left: 128mm; width: 40mm; font: 9pt 楷体;"><%=map.get("ACTNO")%></DIV>
  	
	<!--付款单位开户银行-->
  	<DIV STYLE="position: absolute; top: <%=height1+40%>mm; left: 53mm; font: 9pt 楷体;">浦发银行</DIV>

  	<!--收款单位开户银行-->
  	<DIV STYLE="position: absolute; top: <%=height1+40%>mm; left: 128mm; font: 9pt 楷体;"><%=map.get("BRNAME_BRCODE")%></DIV>
  	
  	<!--金额，大写-->
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 45mm; font: 9pt 楷体;"><%=map.get("CAPITAL")%></DIV>
  	<!--金额，小写-->
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 134mm; font: 9pt 楷体;"><%=moneys[0]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 138mm; font: 9pt 楷体;"><%=moneys[1]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 142mm; font: 9pt 楷体;"><%=moneys[2]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 146mm; font: 9pt 楷体;"><%=moneys[3]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 150mm; font: 9pt 楷体;"><%=moneys[4]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 154mm; font: 9pt 楷体;"><%=moneys[5]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 158mm; font: 9pt 楷体;"><%=moneys[6]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 162mm; font: 9pt 楷体;"><%=moneys[7]%></DIV> 
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 166mm; font: 9pt 楷体;"><%=moneys[8]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 170mm; font: 9pt 楷体;"><%=moneys[9]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 174mm; font: 9pt 楷体;"><%=moneys[10]%></DIV>

  	<!--转账原因-->
  	<DIV STYLE="position: absolute; top: <%=height1+58%>mm; left: 30mm; width: 80mm; font: 9pt 楷体;"><%=map.get("BRCODE")%>共<%=map.get("COUNT")%>笔</DIV>

  	<!--贷方传票-->
	<!--年份-->
  	<DIV id="div1" STYLE="position: absolute; top: <%=height2+14%>mm; left: 86mm; font: 9pt 楷体;"><%=map.get("YEAR")%></DIV>
  	<!--月份-->
  	<DIV STYLE="position: absolute; top: <%=height2+14%>mm; left: 100mm; font: 9pt 楷体;"><%=map.get("MONTH")%></DIV>
  	<!--日期-->
  	<DIV STYLE="position: absolute; top: <%=height2+14%>mm; left: 112mm; font: 9pt 楷体;"><%=map.get("DATE")%></DIV>
  	<!--付款单位全称-->
  	<DIV STYLE="position: absolute; top: <%=height2+19.5%>mm; left: 50mm; width: 40mm; font: 9pt 楷体;">上海市公积金管理中心个贷基金(浦发)专户 </DIV>
  	<!--收款单位全称-->
  	<DIV STYLE="position: absolute; top: <%=height2+19.5%>mm; left: 128mm; font: 9pt 楷体;">待划转代理公积金贷款 </DIV>

  	<!--付款单位帐号-->
	<DIV STYLE="position: absolute; top: <%=height2+28%>mm; left: 53mm; width: 40mm; font: 9pt 楷体;">0764024291025721</DIV>
  	<!--收款单位帐号-->
  	<DIV STYLE="position: absolute; top: <%=height2+28%>mm; left: 128mm; width: 40mm; font: 9pt 楷体;"><%=map.get("ACTNO")%></DIV>
  	
	<!--付款单位开户银行-->
  	<DIV STYLE="position: absolute; top: <%=height2+40%>mm; left: 53mm; font: 9pt 楷体;">浦发银行</DIV>

  	<!--收款单位开户银行-->
  	<DIV STYLE="position: absolute; top: <%=height2+40%>mm; left: 128mm; font: 9pt 楷体;"><%=map.get("BRNAME_BRCODE")%></DIV>
  	
  	<!--金额，大写-->
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 45mm; font: 9pt 楷体;"><%=map.get("CAPITAL")%></DIV>
  	<!--金额，小写-->
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 134mm; font: 9pt 楷体;"><%=moneys[0]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 138mm; font: 9pt 楷体;"><%=moneys[1]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 142mm; font: 9pt 楷体;"><%=moneys[2]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 146mm; font: 9pt 楷体;"><%=moneys[3]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 150mm; font: 9pt 楷体;"><%=moneys[4]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 154mm; font: 9pt 楷体;"><%=moneys[5]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 158mm; font: 9pt 楷体;"><%=moneys[6]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 162mm; font: 9pt 楷体;"><%=moneys[7]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 166mm; font: 9pt 楷体;"><%=moneys[8]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 170mm; font: 9pt 楷体;"><%=moneys[9]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 174mm; font: 9pt 楷体;"><%=moneys[10]%></DIV>

  	<!--转账原因-->
  	<DIV STYLE="position: absolute; top: <%=height2+58%>mm; left: 30mm; width: 80mm; font: 9pt 楷体;"><%=map.get("BRCODE")%>共<%=map.get("COUNT")%>笔</DIV>
<%		i++;
	}	rs.close();
%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>  
