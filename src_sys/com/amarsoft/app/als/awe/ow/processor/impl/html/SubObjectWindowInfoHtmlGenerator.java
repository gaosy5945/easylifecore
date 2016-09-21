package com.amarsoft.app.als.awe.ow.processor.impl.html;

import com.amarsoft.app.als.awe.ow.processor.OWHTMLGenrerator;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASDataWindow;
import com.amarsoft.awe.dw.ui.control.Support;
import com.amarsoft.awe.dw.ui.util.WordConvertor;
import com.amarsoft.awe.ui.model.ButtonItem;
import com.amarsoft.awe.ui.widget.Button;

public class SubObjectWindowInfoHtmlGenerator implements OWHTMLGenrerator{
	private ASDataWindow dwTemp=null;
	private String html="";
	private String javascript="";
	private String jsafterhtml="";
	
	public void setASDataWindow(ASDataWindow dwTemp) throws Exception {
		this.dwTemp=dwTemp;
	}
	
	public String getHtmlResult(String styleId) throws Exception {
		if(dwTemp.Style.equals("1")){
			this.getSubObjectHTML_List();
			dwTemp.CurPage.getCurComp().saveDataObject(dwTemp.getDataObject());
		}
		else{
			this.getSubObjectHTML_Info();
		}
		
		return "";
	}
	
	private String getButtonsHTML(){
		String dwname = ObjectWindowHelper.getObjectWindowName(dwTemp.getDataObject());
		String buttonString = "";
		if("1".equals(dwTemp.ReadOnly))return "";
		String parentColName = this.dwTemp.getDataObject().getCustomProperties().getProperty("ParentColName");
		ButtonItem button_add=new ButtonItem("新增", "新增", "newRecord_"+parentColName+"("+dwname+")");
		ButtonItem button_delete=new ButtonItem("删除", "删除", "deleteRecord_"+parentColName+"("+dwname+")");
		buttonString+=(new Button(button_add).getHtmlText());
		buttonString+=(new Button(button_delete).getHtmlText());
		return buttonString;
	}
	
	private String getSubObjectHTML_List() throws Exception{
		String dwname = ObjectWindowHelper.getObjectWindowName(dwTemp.getDataObject());
		html+="<table class=\"list_data_tablecommon\" id=\"ListTable\">";
		html+="<tr height=1 id=\"ButtonTR1\">";
		html+="<td id=\"ListButtonArea"+dwname+"\" class=\"ListButtonArea\" valign=top>"+getButtonsHTML()+" </td></tr>";

		html+="<tr id=\"DWTR\">";
		html+="<td class=\"listdw_out_data\" id=\"DWTD\" style=\"position:relative;\">";
		html+="<div id=\"Table_Content_"+dwname+"\"></div>";
		html+="</td></tr>";
		html+="<tr height=20><td></td></tr>";
		html+="</table>";
		
		String dzname="DZ["+dwname+"]";
		if("1".equals(dwTemp.ReadOnly)){
			javascript+="bDWConvertCode = true;\n";
		}
		javascript+=dzname+"=new Array();\n";
		javascript+="filterNames["+dwname+"]=new Array();\n";
		javascript+="aDWfilterTitles["+dwname+"]=new Array();\n";
		javascript+=dzname+"[0]=new Array(" + dwTemp.Style + ",'" + dwTemp.Name + "'," + dwTemp.ReadOnly + ",1," + dwTemp.ShowSummary + ",'" + dwTemp.getDataObject().getDONO() + "'," + dwTemp.getDataObject().getLockCount() + ",'" + dwTemp.getDataObject().getJboClass() + "','','');\r\n";
		javascript+=dzname+"[1]=new Array();\r\n";
		for (int i = 0; i < dwTemp.getDataObject().Columns.size(); i++){
			javascript+=dzname+"[1][" + i + "]= new Array("+getListRowArray(dwTemp,i)+");\r\n";
			
			javascript+=dzname+"[1][" + i + "][20]=new Array(";

		     String sEditSourceType = dwTemp.getDataObject().getColumnAttribute(i, "ColEditSourceType");
		      String sEditSource = dwTemp.getDataObject().getColumnAttribute(i, "ColEditSource");

		      String[] sCodeArray = Support.getCodes(sEditSource, sEditSourceType);

		      if ((sCodeArray != null) && (sCodeArray.length > 1)) {
		    	  javascript+="'','',";
		        for (int j = 0; j < sCodeArray.length - 1; j++)
		        	javascript+="'" + sCodeArray[j] + "',";
		        javascript+= "'"+sCodeArray[sCodeArray.length-1] + "');\r\n";
		      } else {
		    	  javascript+=");\r\n";
		      }
		      String sColFilterAttrs = dwTemp.getDataObject().getColumnAttribute(i, "COLFILTERATTRS");
		      if (sColFilterAttrs == null) sColFilterAttrs = "";
		      javascript+=dzname+"[1][" + i + "][21]='" + sColFilterAttrs + "';\n";

		      javascript+=dzname+"[1][" + i + "][22]='" + (dwTemp.getDataObject().getColumnAttribute(i, "ColFilterOptions") == null ? "" : dwTemp.getDataObject().getColumnAttribute(i, "ColFilterOptions")) + "';\n";
		      String sColInnerBTEvent = WordConvertor.convertJava2Js(dwTemp.getDataObject().getColumnAttribute(i, "ColInnerBTEvent"));
		      if (sColInnerBTEvent == null) sColInnerBTEvent = "";
		      javascript+=dzname+"[1][" + i + "][23]='" + sColInnerBTEvent + "';\n";
		}
		
		String generatorClass = dwTemp.getDataObject().getDataQueryClass();
		if(StringX.isEmpty(generatorClass))generatorClass="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator";
		ALSListHtmlGenerator generator = (ALSListHtmlGenerator)Class.forName(generatorClass).newInstance();
		generator.initConstructParams(dwTemp.getDataObject(), dwname, "", dwTemp.getPageSize(), 0, dwTemp.getRequest());
		generator.beforeRun(JBOFactory.createJBOTransaction());
		generator.run(null);
		String listdatascript = generator.getHtmlResult();
		
		
		javascript+=dzname+"[0][8]='" + dwTemp.getDataObject().getSerializableName() + "';\n";
		if ((dwTemp.getSerializedJBOs() != null) && (dwTemp.getSerializedJBOs().length > 0)) {
			StringBuffer sbJbos = new StringBuffer();
	        for (int k = 0; k < dwTemp.getSerializedJBOs().length; k++)
	          sbJbos.append("," + dwTemp.getSerializedJBOs()[k]);
	        javascript+=dzname+"[0][9]='" + sbJbos.toString().substring(1) + "';\n";
	    }

	    if (dwTemp.MultiSelect)
	    	javascript+=dzname+"[0][11]=1;\n";
	    else
	    	javascript+=dzname+"[0][11]=0;\n";
	    javascript+=listdatascript+"\n";

	    if ((dwTemp.CombineLeft != null) && (!dwTemp.CombineLeft.equals("")) && (dwTemp.CombineRight != null) && (!dwTemp.CombineRight.equals(""))) {
	    	javascript+=dzname+"[4]=[[" + dwTemp.CombineLeft + "],[" + dwTemp.CombineRight + "]];\n";
	    }

	    if (dwTemp.getDataObject().getColumnDisplayArray() != null) {
	    	javascript+=dzname+"[6]= new Array();\n";
	      for (int ii = 0; ii < dwTemp.getDataObject().getColumnDisplayArray().length; ii++) {
	        String sTmp = "";
	        for (int jj = 0; jj < dwTemp.getDataObject().getColumnDisplayArray()[ii].length; jj++) {
	          if (sTmp.equals(""))
	            sTmp = "\"" + dwTemp.getDataObject().getColumnDisplayArray()[ii][jj] + "\"";
	          else
	            sTmp = sTmp + ",\"" + dwTemp.getDataObject().getColumnDisplayArray()[ii][jj] + "\"";
	        }
	        javascript+=dzname+"[6][" + ii + "]= [" + sTmp + "];\n";
	      }
	    }
	    javascript+="TableBuilder.subListLeftColspan=" + dwTemp.getSubListLeftColspan() + "\n";
	    
		return html;
	}
	
	private String getListRowArray(ASDataWindow datawindow,int iCol) throws JBOException{
		String[] aColKeys = new String[0];
		ASDataObject asObj=datawindow.getDataObject();
	    if ((asObj.getJboClass() != null) && (asObj.getJboClass().trim().length() > 0))
	      aColKeys = JBOFactory.getFactory().getClass(asObj.getJboClass()).getKeyAttributes();
		
		String[] sAttribute=new String[20];
		sAttribute[0] = "'" + WordConvertor.convertJava2Js(asObj.getColumnAttribute(iCol, "ColHeader")) + "'";

	      if (datawindow.isInArray(aColKeys, asObj.getColumnAttribute(iCol, "ColName")))
	        sAttribute[1] = "1";
	      else
	        sAttribute[1] = "0";
	      sAttribute[2] = asObj.getColumnAttribute(iCol, "ColVisible");
	      sAttribute[3] = asObj.getColumnAttribute(iCol, "ColReadOnly");
	      sAttribute[4] = asObj.getColumnAttribute(iCol, "ColRequired");
	      sAttribute[5] = "0";
	      sAttribute[6] = asObj.getColumnAttribute(iCol, "ColSortable");
	      sAttribute[7] = asObj.getColumnAttribute(iCol, "ColLimit");
	      if ((asObj.getColumnAttribute(iCol, "ColLimit") == null) || (asObj.getColumnAttribute(iCol, "ColLimit").trim().equals("")))
	        sAttribute[7] = "0";
	      sAttribute[8] = asObj.getColumnAttribute(iCol, "ColAlign");
	      sAttribute[9] = ("'" + WordConvertor.convertJava2Js(asObj.getColumnAttribute(iCol, "ColDefaultValue")) + "'");
	      sAttribute[10] = ("' " + WordConvertor.convertJava2Js(asObj.getColumnAttribute(iCol, "ColHTMLStyle")) + " '");
	      sAttribute[11] = ("'" + asObj.getColumnAttribute(iCol, "ColEditStyle") + "'");
	      String sCheckFormat = asObj.getColumnAttribute(iCol, "ColCheckFormat");
	      if ((sCheckFormat == null) || (sCheckFormat.equals("")))
	        sCheckFormat = "1";
	      sAttribute[12] = sCheckFormat;
	      sAttribute[13] = "''";
	      String sColColumnType = asObj.getColumnAttribute(iCol, "ColColumnType");
	      sAttribute[14] = sColColumnType;

	      sAttribute[15] = ("'" + asObj.getColumnAttribute(iCol, "ColName") + "'");
	      sAttribute[16] = "0";
	      String sColUnit = WordConvertor.convertJava2Js(asObj.getColumnAttribute(iCol, "ColUnit"));
	      if (sColUnit == null) sColUnit = "";
	      sAttribute[17] = ("'" + sColUnit + "'");
	      sAttribute[18] = "'0'";
	      sAttribute[19] = ("'" + (asObj.getColumnAttribute(iCol, "ColFilterRefID") == null ? "" : asObj.getColumnAttribute(iCol, "ColFilterRefID")) + "'");
	      
	      String result ="";
	      for (int i = 0; i < sAttribute.length - 1; i++)
	    	  result+=sAttribute[i] + ",";
	      result+=sAttribute[19];
	      return result;
	}
	
	private String getSubObjectHTML_Info() throws Exception{
		String replacestring="<tr><td  height=\"13\" valign=\"top\"><table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">  <tr>    <td width=\"50%\" align=\"left\" valign=\"top\"  class=\"info_bottom_line_left\"></td>     <td width=\"50%\" align=\"right\" valign=\"top\"  class=\"info_bottom_line_right\" ></td>  </tr></table></td></tr>";
		
		String generatorClass = dwTemp.getDataObject().getDataQueryClass();
		if(StringX.isEmpty(generatorClass))generatorClass="com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator";
		ALSInfoHtmlGenerator generator = (ALSInfoHtmlGenerator)Class.forName(generatorClass).newInstance();
		generator.initBasicParams(dwTemp.getDataObject(), "", dwTemp.getWebRootPath(), dwTemp.getRequest());
		if (dwTemp.ReadOnly.equals("1"))
			generator.setInputStatus(2);
		else if (dwTemp.ReadOnly.equals("-2"))
			generator.setInputStatus(-2);
		generator.run(null);
		generator.getHtmlResult(dwTemp.getDataObject().getStyleId());
		dwTemp.CurPage.getCurComp().saveDataObject(dwTemp.getDataObject());
		String formid=ObjectWindowHelper.getObjectWindowFormName(dwTemp.getDataObject());
		String subhtml=generator.getHTML();
		html+=subhtml.replaceAll(replacestring, "")+"\n";
		javascript+=generator.getJavaScript();
		return html;
	}

	public String getJavaScript() throws Exception {
		return this.javascript;
	}
	
	public String getJSAfterHTML() throws Exception {
		return this.jsafterhtml;
	}

	public String getHTML() throws Exception {
		return this.html;
	}
}
