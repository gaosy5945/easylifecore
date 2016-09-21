<%@page import="com.amarsoft.are.util.json.JSONElement"%>
<%@page import="com.amarsoft.are.util.json.JSONDecoder"%>
<%@page import="com.amarsoft.are.util.json.JSONEncoder"%>
<%@page import="com.amarsoft.are.util.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/Frame/resources/include/include_begin.jspf" %>
<html>
<%
	String sWizardId = CurPage.getParameter("WizardId");
	if(sWizardId == null) throw new IllegalArgumentException("向导编号WizardId参数为空");
	String sObjectNo = CurPage.getParameter("ObjectNo");

	JSONObject wizard = null;
	
	String sWizard = Sqlca.getString(new SqlObject("select WizardInfo from AWE_WIZARD_RUNNER where WizardId = :WizardId and ObjectNo = :ObjectNo ").setParameter("WizardId", sWizardId).setParameter("ObjectNo", sObjectNo));
	if(sWizard != null) wizard = JSONDecoder.decode(sWizard);
	
	if(wizard == null){
		wizard = JSONObject.createObject();
		Element e;
		
		e = new JSONElement("WizardId");
		e.setValue(sWizardId);
		wizard.add(e);
		
		e = new JSONElement("ObjectNo");
		e.setValue(sObjectNo);
		wizard.add(e);
		
		String sWizardName = Sqlca.getString(new SqlObject("select WizardName from AWE_WIZARD_CATALOG where WizardId = :WizardId").setParameter("WizardId", sWizardId));
		e = new JSONElement("Name");
		e.setValue(sWizardName);
		wizard.add(e);
		
		e = new JSONElement("CurIndex");
		e.setValue(0);
		wizard.add(e);
		
		ASResultSet rs = null;
		try{
			rs = Sqlca.getASResultSet(new SqlObject("select ItemNo, ItemName, Url, Params from AWE_WIZARD_LIBRARY where WizardId = :WizardId order by SortNo").setParameter("WizardId", sWizardId));
			JSONObject items = JSONObject.createArray();
			e = new JSONElement("Items");
			e.setValue(items);
			wizard.add(e);
			
			while(rs.next()){
				String sParams = rs.getString("Params");
				if(sParams == null) sParams = "";
				
				JSONObject item = JSONObject.createObject();
				e = new JSONElement();
				e.setValue(item);
				items.add(e);

				e = new JSONElement("ItemNo");
				e.setValue(rs.getString("ItemNo"));
				item.add(e);
				e = new JSONElement("ItemName");
				e.setValue(rs.getString("ItemName"));
				item.add(e);
				e = new JSONElement("Url");
				e.setValue(rs.getString("Url"));
				item.add(e);
				e = new JSONElement("Params");
				e.setValue(sParams);
				item.add(e);
				e = new JSONElement("RunParams");
				if(sObjectNo != null) sParams = sParams.replace("#{ObjectNo}", sObjectNo);
				e.setValue(sParams);
				item.add(e);
			}
		}finally{
			if(rs != null) rs.close();
			rs = null;
		}
	}
%>
<head>
<title><%=wizard.getValue("Name")%></title>
<script type="text/javascript" src="<%=sWebRootPath%>/Frame/resources/js/chart/json2.js"></script>
</head>
<body style="height:100%;overflow:hidden;">
<iframe name="wizard" style="height:100%;width:100%;" frameborder="0" ></iframe>
</body>
<script type="text/javascript">
	function Wizard(data){
		//alert(JSON.stringify(data));

		/**
		 * 获取对象编号
		 */
		this.getObjectNo = function(){
			return data["ObjectNo"];
		};
		
		/**
		 * 设置对象编号
		 * @throws e 对象编号已存在，且与设置的编号不同
		 */
		this.setObjectNo = function(sObjectNo){
			if(data["ObjectNo"] && data["ObjectNo"] != sObjectNo){
				throw {"message":"对象编号已绑定"};
			}
			data["ObjectNo"] = sObjectNo;
		};
		
		/**
		 * 获取向导步骤
		 */
		this.getItems = function(){
			return data["Items"];
		};
		
		this.getCurIndex = function(){
			return data["CurIndex"];
		};
		
		/**
		 * 跳转到下一步
		 */
		this.toNextStep = function(){
			this.toStep(data["CurIndex"]+1);
		};
		
		/**
		 * 回退到上一步
		 */
		this.toPrevStep = function(){
			this.toStep(data["CurIndex"]-1);
		};
		
		/**
		 * 跳转到指定步骤
		 * @throws e 指定步骤不在向导步骤范围内
		 */
		this.toStep = function(index){
			if(index < 0 || index > data["Items"].length - 1){
				throw {"message":"超出数组异常"};
			}
			if(data["CurIndex"] != index && data["ObjectNo"]){
				var curIndex = data["CurIndex"];
				data["CurIndex"] = index;
				var result = AsControl.RunJavaMethodSqlca("com.amarsoft.awe.ui.wizard.WizardAction", "recode", "{\"WizardInfo\":"+JSON.stringify(data)+"}");
				if(!result){
					data["CurIndex"] = curIndex;
					return;
				}
				if(typeof result == "string"){
					alert(result);
					data["CurIndex"] = curIndex;
					return;
				}
				data = result;
			}
			AsControl.OpenView(data["Items"][data["CurIndex"]]["Url"], data["Items"][data["CurIndex"]]["RunParams"], "wizard");
			if(typeof window.setDialogTitle == "function"){
				var sText = "";
				for(var i = 0; i < data["Items"].length; i++){
					if(i != 0){
						sText += "<span style='padding:0 5px;";
						if(i != data["CurIndex"]) sText += "color:#999;";
						sText += "'>→</span>";
					}
					sText += "<span style='white-space:nowrap;";
					if(i != data["CurIndex"]) sText += "color:#999;";
					sText += "'>";
					sText += data["Items"][i]["ItemName"];
					sText += "</span>";
				}
				setDialogTitle(sText);
			}
		};
		
		/**
		 * 重载当前步骤
		 */
		this.reload = function(){
			this.toStep(data["CurIndex"]);
			if(typeof window.setWindowTitle == "function")
				setWindowTitle(data["Name"]);
		};

		this.reload();
	}

	var wizard = new Wizard(<%=JSONEncoder.encode(wizard)%>);
</script>
</html>
<%@ include file="/Frame/resources/include/include_end.jspf" %>