<%@page import="com.amarsoft.app.als.sys.org.OrgConfig"%><%@ page contentType="text/html; charset=GBK"%><%@ include file="/Frame/resources/include/include_begin.jspf"%>

<META HTTP-EQUIV="expires" CONTENT="-1">
<%	String serialNo = CurPage.getParameter("SerialNo");	if(serialNo == null)	serialNo = "";	 	String occurDate = "",subOrgID = "",subOrgName="",reAcctNo = "";	double amount=0d;	ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select OccurDate,SubOrgID,sum(Amount) as Amount,count(*) as cnt from fund_transfer where SerialNo in('"+serialNo.replaceAll(",", "','")+"') group by OccurDate,SubOrgID order by OccurDate,SubOrgID"));		int i = 0;
	//for (int i = 0; i < list.size(); i++) {	while(rs.next())	{			occurDate = rs.getString("OccurDate");			subOrgID = rs.getString("SubOrgID");			amount = rs.getDouble("Amount");			int cnt = rs.getInt("cnt");						String YEAR = occurDate.substring(0,4);//��			String MONTH = occurDate.substring(5, 7);//��			String DATE = occurDate.substring(8, 10);//��						BusinessObject org = OrgConfig.getOrg(subOrgID);					double height1 = 0.0d;					double height2 = 0.0d;							char[] moneys = new char[11];			
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

            //ת��Сд���ݡ�
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
            	moneys[moneys.length-j-1] = '��';
            }

%>
	<!--�跽��Ʊ****************************-->
	<!--���-->
  	<DIV id="div1" STYLE="position: absolute; top: <%=height1+14%>mm; left: 86mm; font: 9pt ����;"><%=map.get("YEAR")%></DIV>
  	<!--�·�-->
  	<DIV STYLE="position: absolute; top: <%=height1+14%>mm; left: 100mm; font: 9pt ����;"><%=map.get("MONTH")%></DIV>
  	<!--����-->
  	<DIV STYLE="position: absolute; top: <%=height1+14%>mm; left: 112mm; font: 9pt ����;"><%=map.get("DATE")%></DIV>
  	<!--���λȫ��-->
  	<DIV STYLE="position: absolute; top: <%=height1+19.5%>mm; left: 50mm; width: 40mm; font: 9pt ����;">�Ϻ��й�����������ĸ�������(�ַ�)ר�� </DIV>
  	<!--�տλȫ��-->
  	<DIV STYLE="position: absolute; top: <%=height1+19.5%>mm; left: 128mm; font: 9pt ����;">����ת����������� </DIV>
  	<!--���λ�ʺ�-->
	<DIV STYLE="position: absolute; top: <%=height1+28%>mm; left: 53mm; width: 40mm; font: 9pt ����;">0764024291025721</DIV>
  	<!--�տλ�ʺ�-->
  	<DIV STYLE="position: absolute; top: <%=height1+28%>mm; left: 128mm; width: 40mm; font: 9pt ����;"><%=map.get("ACTNO")%></DIV>
  	
	<!--���λ��������-->
  	<DIV STYLE="position: absolute; top: <%=height1+40%>mm; left: 53mm; font: 9pt ����;">�ַ�����</DIV>

  	<!--�տλ��������-->
  	<DIV STYLE="position: absolute; top: <%=height1+40%>mm; left: 128mm; font: 9pt ����;"><%=map.get("BRNAME_BRCODE")%></DIV>
  	
  	<!--����д-->
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 45mm; font: 9pt ����;"><%=map.get("CAPITAL")%></DIV>
  	<!--��Сд-->
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 134mm; font: 9pt ����;"><%=moneys[0]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 138mm; font: 9pt ����;"><%=moneys[1]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 142mm; font: 9pt ����;"><%=moneys[2]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 146mm; font: 9pt ����;"><%=moneys[3]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 150mm; font: 9pt ����;"><%=moneys[4]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 154mm; font: 9pt ����;"><%=moneys[5]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 158mm; font: 9pt ����;"><%=moneys[6]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 162mm; font: 9pt ����;"><%=moneys[7]%></DIV> 
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 166mm; font: 9pt ����;"><%=moneys[8]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 170mm; font: 9pt ����;"><%=moneys[9]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height1+50%>mm; left: 174mm; font: 9pt ����;"><%=moneys[10]%></DIV>

  	<!--ת��ԭ��-->
  	<DIV STYLE="position: absolute; top: <%=height1+58%>mm; left: 30mm; width: 80mm; font: 9pt ����;"><%=map.get("BRCODE")%>��<%=map.get("COUNT")%>��</DIV>

  	<!--������Ʊ-->
	<!--���-->
  	<DIV id="div1" STYLE="position: absolute; top: <%=height2+14%>mm; left: 86mm; font: 9pt ����;"><%=map.get("YEAR")%></DIV>
  	<!--�·�-->
  	<DIV STYLE="position: absolute; top: <%=height2+14%>mm; left: 100mm; font: 9pt ����;"><%=map.get("MONTH")%></DIV>
  	<!--����-->
  	<DIV STYLE="position: absolute; top: <%=height2+14%>mm; left: 112mm; font: 9pt ����;"><%=map.get("DATE")%></DIV>
  	<!--���λȫ��-->
  	<DIV STYLE="position: absolute; top: <%=height2+19.5%>mm; left: 50mm; width: 40mm; font: 9pt ����;">�Ϻ��й�����������ĸ�������(�ַ�)ר�� </DIV>
  	<!--�տλȫ��-->
  	<DIV STYLE="position: absolute; top: <%=height2+19.5%>mm; left: 128mm; font: 9pt ����;">����ת����������� </DIV>

  	<!--���λ�ʺ�-->
	<DIV STYLE="position: absolute; top: <%=height2+28%>mm; left: 53mm; width: 40mm; font: 9pt ����;">0764024291025721</DIV>
  	<!--�տλ�ʺ�-->
  	<DIV STYLE="position: absolute; top: <%=height2+28%>mm; left: 128mm; width: 40mm; font: 9pt ����;"><%=map.get("ACTNO")%></DIV>
  	
	<!--���λ��������-->
  	<DIV STYLE="position: absolute; top: <%=height2+40%>mm; left: 53mm; font: 9pt ����;">�ַ�����</DIV>

  	<!--�տλ��������-->
  	<DIV STYLE="position: absolute; top: <%=height2+40%>mm; left: 128mm; font: 9pt ����;"><%=map.get("BRNAME_BRCODE")%></DIV>
  	
  	<!--����д-->
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 45mm; font: 9pt ����;"><%=map.get("CAPITAL")%></DIV>
  	<!--��Сд-->
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 134mm; font: 9pt ����;"><%=moneys[0]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 138mm; font: 9pt ����;"><%=moneys[1]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 142mm; font: 9pt ����;"><%=moneys[2]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 146mm; font: 9pt ����;"><%=moneys[3]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 150mm; font: 9pt ����;"><%=moneys[4]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 154mm; font: 9pt ����;"><%=moneys[5]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 158mm; font: 9pt ����;"><%=moneys[6]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 162mm; font: 9pt ����;"><%=moneys[7]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 166mm; font: 9pt ����;"><%=moneys[8]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 170mm; font: 9pt ����;"><%=moneys[9]%></DIV>
  	<DIV STYLE="position: absolute; top: <%=height2+50%>mm; left: 174mm; font: 9pt ����;"><%=moneys[10]%></DIV>

  	<!--ת��ԭ��-->
  	<DIV STYLE="position: absolute; top: <%=height2+58%>mm; left: 30mm; width: 80mm; font: 9pt ����;"><%=map.get("BRCODE")%>��<%=map.get("COUNT")%>��</DIV>
<%		i++;
	}	rs.close();
%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>  
