<%@ page import="com.amarsoft.app.lending.bizlets.*,java.util.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%><%
	String PG_TITLE = "���Ź�������"; // ��������ڱ��� <title> PG_TITLE </title>
	String PG_CONTENT_TITLE = "&nbsp;&nbsp;��ϸ��Ϣ&nbsp;&nbsp;"; //Ĭ�ϵ�����������
	String PG_CONTNET_TEXT = "��������б�";//Ĭ�ϵ�����������
	String PG_LEFT_WIDTH = "2000";//Ĭ�ϵ�treeview����
	//����������	���ͻ����
	String sCustomerID  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null ) sCustomerID="";
	
	//���������SQL���
	String sSql = "";
	ASResultSet rs = null;//-- ��Ž����
	
	String sCustomerName ="";
	String sCustomerType ="";
	String sCertType ="";
	String sCertID ="";
	String sSerialNo ="";
	
	Hashtable sGroupRelaCustomerHt = new Hashtable();
	String sGroupRelaCustStr1 = "";//������ͻ���
	String sGroupRelaCustStr2 = "";//�������ϵ��
	Vector sGroupRelaCustomerVr = new Vector();//�洢�ӹ���������õ���Vector,���д��й����ͻ�����������Ϣ.
	String keys ="";//�洢�ӹ���������õ���Vector��ȡ�Ĺ����ͻ�ID
	String value ="";//�洢�������õ���HashTable��ȡ��ֵ.
	String sCustomerStr ="";//�洢�������õ���CustoemrResult��ȡ��ֵ.

	String sButtons[][] = {	
		{"true","","Button","ȷ��","���漯�Ź�������","save()","","","",""},
		{"true","","Button","���������϶���","���������϶���","nextStep()","","","",""},		
	};

	//��ȡ��������Դ�ͻ��Ŀͻ���Ϣ.
	sSql = "select CustomerName,CustomerType,getItemName('CertType',CertType) as CertType1,CertID from CUSTOMER_INFO where CustomerID = :CustomerID ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("CustomerID",sCustomerID));
	while(rs.next()){
		sCustomerName = rs.getString("CustomerName");
		sCustomerType = rs.getString("CustomerType");
		sCertType = rs.getString("CertType1");
		sCertID = rs.getString("CertID");
	}
	rs.getStatement().close();
	
	//����Treeview
	HTMLTreeView tviTemp = new HTMLTreeView("��������ϵͼ��","_top");
	tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�

	//ʵ��������������
	GroupRelaSearch	groupSearch = new GroupRelaSearch(sCustomerID);
	try{
		groupSearch.SearchAction(Sqlca);//���й����ͻ�������ϵ����.
		sGroupRelaCustomerVr =groupSearch.getVSearchCustomer();//��ȡ������ɺ󱣴�����ͻ�CustomerIDֵ.
		sGroupRelaCustomerHt =groupSearch.getMyHashtable();//��ȡ������ɺ󱣴�����ͻ��Ŀͻ�����������Ϣ.
		sCustomerStr =groupSearch.getCustomerResult();//��ȡ������ɺ���$���ŷָ�������ౣ��Ĺ����ͻ���CustomerID����@�ָ�ĳ�������ַ���sCustomerStr.
	}
	catch(Exception e){
		ARE.getLog().error(e.getMessage());	
	}

	String[] terms = sCustomerStr.split("$");//����split�����������,sCustomerStr�ָ��ĳ���δ֪.
	String termResult ="";//ֻ������������������ݿ�ǰ�Ĳ����ַ�����Ԥƴ��.	
	for(int ii=0;ii<terms.length;ii++){		
		termResult +=terms[ii];
		termResult +=",";
	}

	//������ͼ
	//����Root������.
	String sRoot=tviTemp.insertFolder("root",sCustomerName+"    "+sCertType+":"+sCertID,"",1);
	
	String[] values = new String[3];
	Enumeration enumer= sGroupRelaCustomerVr.elements() ;
	
	int num = 2,num0 =0;
	String temp ="00";
	String[] tmp= new String[5];

	while(enumer.hasMoreElements()){
		keys=(String)enumer.nextElement();
		value=(String)sGroupRelaCustomerHt.get(keys);	
		values = value.split("@");//����һ:��������;������:�ͻ�����;������:��������;������չ�������Ϣ.
		//����������.
		if(!temp.equals(values[0])){			
			temp= values[0];
			if(values[0].equals("0100")){
				tmp[0]= tviTemp.insertFolder(sRoot,"��ͬ���˴����Ĺ����ͻ�","",num); 			
			}				
			if(values[0].equals("0200")){
				tmp[1]= tviTemp.insertFolder(sRoot,"�ع�����������˾�ͻ�","",num); num++;	
			}				
			if(values[0].equals("5200")){
				tmp[2]= tviTemp.insertFolder(sRoot,"���عɹ�����˾�ͻ�","",num); num++;
			}				
			if(values[0].equals("0250")){
				tmp[3]= tviTemp.insertFolder(sRoot,"ͬ��һ�ҹɶ���˾�عɵĹ�����˾�ͻ�","",num); num++;
			}				
			if(values[0].equals("0300")){
				tmp[4]= tviTemp.insertFolder(sRoot,"����������˾","",num); num++;
			}				
		}
		sGroupRelaCustStr1 +=keys;sGroupRelaCustStr1 +="@";//ƴ���ַ���
		sGroupRelaCustStr2 +=values[0];sGroupRelaCustStr2 +="@";//ƴ���ַ���
		
		if(values[0].equals("0100")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[0],values[1],"","",num);num++;
		}
		if(values[0].equals("0200")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[1],values[1],"","",num);num++;
		}
		if(values[0].equals("5200")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[2],values[1],"","",num);num++;
		}
		if(values[0].equals("0250")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[3],values[1],"","",num);num++;
		}
		if(values[0].equals("0300")){
			tviTemp.insertPage(sCustomerID+"@"+values[1]+"@"+values[2]+"@"+keys,tmp[4],values[1],"","",num); num++;
		}					
	}

%><%@include file="/Resources/CodeParts/View07.jsp"%>
<script type="text/javascript">
	var boolvalue ="" ;
	var curUser ="";
	
	/*~[Describe=�������������϶������ҳ��;InputParam=��;OutPutParam=��;]~*/	
	function nextStep(){
		//�������������϶������ҳ��.
		//����GROUP_RESULT��ˮ��
		var curUser2="<%=CurUser.getUserID()%>";
		var CurNum ="<%=sGroupRelaCustomerVr.size()%>";

		if(CurNum<=1)
			alert("�޹����ͻ����޷����ɡ������϶��顱.");
		else{	
			if(boolvalue=="")
				alert("������ȷ�����������Ϣ.");		
			else{
				if(curUser2 !=curUser){
					//ȷ�ϵ�������������϶��顱��ťǰ���ѱ���������Ϣ��
					if(confirm("���ڱ���ͻ������ǵ�ǰ�ͻ�.������ȷ�ϱ���������Ϣ.")){
						popComp("GroupApplyManage","/CustomerManage/GroupManage/GroupApplyManage.jsp","SerialNo="+boolvalue,"");
					}
				}else{
					popComp("GroupApplyManage","/CustomerManage/GroupManage/GroupApplyManage.jsp","SerialNo="+boolvalue,"");
				}				
			}
		}																								
	}
	
	//treeview����ѡ���¼�
	function TreeViewOnClick(){
		var sCurItemID = getCurTVItem().id;		
		if(sCurItemID == "root" ||sCurItemID.length <= 6)	//6,��ʾ��ȡ�Ľ��IDֵ����С��6,����ΪCustomerIDֵ����,һ�����6,����һЩ��ʷ����.	
			return;
		
		var sCurItemName = getCurTVItem().name;
		var sCurItemValue = getCurTVItem().value;
		if (sCurItemValue.length == 1) {
			alert("�ÿͻ�����ϸ��Ϣ��");
			return;
		}
		var sss = sCurItemID.split("@");
		var sCustomerID=sss[3];
		AsCredit.openFunction("CustomerDetail","CustomerID="+sCustomerID,"");   		
		//openObject("Customer",sCustomerID,"002");
	}		

	/*~[Describe=������¹�����ϵ���;InputParam=��;OutPutParam=��;]~*/
	function save(){
		var sCustomerID = "<%=sCustomerID%>";
		if(boolvalue!= "")
			alert("���Ѿ��ظ�ȷ��!��ǰ��������ˮ��Ϊ"+boolvalue);
		else{
			boolvalue = RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.SaveRelaResult","saveRelaResult","customerID="+sCustomerID+",groupRelaCustStr1="+"<%=sGroupRelaCustStr1%>"+",groupRelaCustStr2="+"<%=sGroupRelaCustStr2%>"+",customerStr="+"<%=sCustomerStr%>"+",userID="+"<%=CurUser.getUserID()%>");
			if(boolvalue != null && boolvalue!= "" ){
				alert("����ɹ�");
				curUser="<%=CurUser.getUserID()%>";	
			}else{
				alert("���治�ɹ�");boolvalue="";		
			}
		}					
	}
	
	function startMenu(){
		<%=tviTemp.generateHTMLTreeView()%>
	}

	startMenu();
	expandNode('root');
</script>
<%@ include file="/IncludeEnd.jsp"%>