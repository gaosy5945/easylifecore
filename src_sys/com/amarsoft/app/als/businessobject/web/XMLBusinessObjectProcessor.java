package com.amarsoft.app.als.businessobject.web;
import java.lang.reflect.Method;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;






import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.ASDataObjectFilter;
import com.amarsoft.awe.util.StringMatch;

public class XMLBusinessObjectProcessor extends ALSBusinessProcess implements BusinessObjectOWQuerier{
	private int totalCount = 0;
	
	
	public List<BusinessObject> save(List<BusinessObject> list) throws Exception{
		
		String xmlFile = this.asPage.getParameter("XMLFile");
		String xmlTags = this.asPage.getParameter("XMLTags");
		String keys = this.asPage.getParameter("Keys");
		
		List<BusinessObject> ls = new ArrayList<BusinessObject>();
		
		for(int i=0;i<list.size();i++){
			BusinessObject businessObject = list.get(i);
			this.setDefaultValue(businessObject);
			businessObject=convertBusinessObject(businessObject);//根据主对象属性，更新附属对象属性
			this.getBusinessObjectUpdater().update(businessObject, this);
			refreshExtendedAttributes(businessObject);//保存操作执行后，再将主对象属性进行同步，保证返给前台是正确的。
			
			for(String key:keys.split(","))
			{
				if(StringX.isEmpty(businessObject.getString("OLDVALUEBACKUP"+key)))
					businessObject.setAttributeValue("OLDVALUEBACKUP"+key, businessObject.getString(key));
			}
			
			
			BusinessObject bo = BusinessObject.createBusinessObject();
			String[] attributes = businessObject.getAttributeIDArray();
			for(String attribute:attributes)
			{
				boolean virtualFlag = false;
				for(String virtualFields :asDataObject.getVirtualFields())
				{
					if(virtualFields.equalsIgnoreCase(attribute))
						virtualFlag = true;
				}
				
				if(asDataObject.getColumn(attribute) != null && !virtualFlag)
					bo.setAttributeValue(attribute, businessObject.getObject(attribute));
			}
			bo.removeAttribute("SYS_SERIALNO");
			ls.add(bo);
		}
		
		XMLHelper.saveBusinessObjectList(xmlFile, xmlTags, keys, ls);
		
		return list;
	}
	
	
	
	public List<BusinessObject> delete(List<BusinessObject> list) throws Exception{
		String xmlFile = this.asPage.getParameter("XMLFile");
		String xmlTags = this.asPage.getParameter("XMLTags");
		String keys = this.asPage.getParameter("Keys");
		
		
		
		for(int i=0;i<list.size();i++){
			BusinessObject businessObject = list.get(i);
			businessObject=convertBusinessObject(businessObject);//根据主对象属性，更新附属对象属性
			if(businessObject.getState()!=StateBizObject.STATE_NEW){
				this.getBusinessObjectDeleter().delete(businessObject, this);
			}
		}
		
		XMLHelper.deleteBusinessObjectList(xmlFile, xmlTags, keys, list);
		
		return list;
	}
	
	
	@Override
	public int query(BusinessObject inputParameters,ALSBusinessProcess businessProcess) throws Exception {
		this.getBusinessObjectList(0, 15);
		return this.totalCount;
	}
	@Override
	public BusinessObject[] getBusinessObjectList(int fromIndex, int toIndex) throws Exception {
		
		String xmlFile = this.asPage.getParameter("XMLFile");
		String xmlTags = this.asPage.getParameter("XMLTags");
		String keys = this.asPage.getParameter("Keys");
		
		BizObjectClass bizClass = ObjectWindowHelper.getBizObjectClass(this.asDataObject);
		
		
		if(this.asDataObject.Filters!=null){
			String[] tags = xmlTags.split("//");
			if(tags[tags.length-1].indexOf("||") == -1)
				xmlTags += "|| 1=1 ";
			for(int k=0;k<asDataObject.Filters.size();k++){
				ASDataObjectFilter asFilter = (ASDataObjectFilter)asDataObject.Filters.get(k);
				if(asFilter.sFilterInputs!=null){
					String sColName = asFilter.acColumn.getAttribute("ColName").toUpperCase();
					String sColFilterRefId = asDataObject.getColumn(sColName).getAttribute("COLFILTERREFID");
					if(sColFilterRefId!=null && sColFilterRefId.length()>0)
						sColName = sColFilterRefId.toUpperCase();//sColName = sColFilterRefId;
					//ARE.getLog().trace("sColName = " + sColName);
					String option = "";//Request.GBKSingleRequest("DOFILTER_DF_"+ sColName +"_1_OP",request);
					String value = "";//Request.GBKSingleRequest("DOFILTER_DF_"+ sColName +"_1_VALUE",request);
					String value2 = "";
					if(request.getParameter("DOFILTER_DF_"+ sColName +"_1_OP")!=null){
						option = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ sColName +"_1_OP").toString(),"UTF-8");
						//ARE.getLog().trace("option=" + option);
					}
					if(request.getParameter("DOFILTER_DF_"+ sColName +"_1_VALUE")!=null){
						value = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ sColName +"_1_VALUE").toString(),"UTF-8");
						//ARE.getLog().trace("value1 = " + value);
					}
					if(request.getParameter("DOFILTER_DF_"+ sColName +"_2_VALUE")!=null){
						value2 = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ sColName +"_2_VALUE").toString(),"UTF-8");
						//ARE.getLog().trace("value2 = " + value2);
					}
					
					if(option.equalsIgnoreCase("In")){
						
					}else{
						
					}
					
					if(option.equalsIgnoreCase("In")){
						if(StringX.isEmpty(value)) continue;
						xmlTags += " and "+sColName+" in('"+value.replaceAll("\\|", ",")+"')";
					}
					else if(option.equalsIgnoreCase("Area")){
						if(StringX.isEmpty(value)&&StringX.isEmpty(value2)) continue;
						xmlTags += " and "+sColName+" between "+value+" and "+value2;
					}
					else if(option.equalsIgnoreCase("Like")){
						if(StringX.isEmpty(value)) continue;
						xmlTags += " and "+sColName+" like '"+value+"'";
					}
					else if(option.equalsIgnoreCase("BeginsWith")){
						if(StringX.isEmpty(value)) continue;
						xmlTags += " and "+sColName+" like '"+value+"'";
					}else{
						if(StringX.isEmpty(value)) continue;
						xmlTags += " and "+sColName+" = '"+value+"'";
					}
				}
			}
		}
		
		List<BusinessObject> ls = XMLHelper.getBusinessObjectList(xmlFile,xmlTags,keys);
		totalCount = ls.size();
		if(toIndex>ls.size()) toIndex = ls.size();
		
		BusinessObject[] businessObjectArray = new BusinessObject[toIndex-fromIndex];
		for(int i=fromIndex;i<toIndex;i++){
			businessObjectArray[i-fromIndex]=BusinessObject.createBusinessObject(bizClass);
			for(int j=0; j < this.asDataObject.Columns.size(); j ++)
			{
				String colname = this.asDataObject.getColumn(j).getAttribute("ColName");
				businessObjectArray[i-fromIndex].setAttributeValue(colname,ls.get(i).getObject(colname));
			}
			
			for(String colName : this.asDataObject.getVirtualFields())
			{
				parseStaticFunction(businessObjectArray[i-fromIndex],colName,this.asDataObject.getColumn(colName).getAttribute("ColActualName"));
			}
		}
		return businessObjectArray;
	}

	private void parseStaticFunction(BusinessObject bo,String colName, String function) throws Exception
	{
		if (function == null) return;
		int iDot2 = function.indexOf("(");
		int iDot = function.substring(0, iDot2).lastIndexOf(".");
		
		String reflectClassName = function.substring(0, iDot);
		
		if (reflectClassName.indexOf(".") == -1) {
		  reflectClassName = ("com.amarsoft.dict.als.manage." + reflectClassName);
		}
		String reflectFunctionName = function.substring(iDot + 1, iDot2);
		function = StringMatch.getContent(function, "\\([\\w\\W]+?\\)");
		function = function.substring(1, function.length() - 1);
		String[] tmp = function.split("\\,");
		Class<?>[] reflectParamTypes = new Class[tmp.length];
		String[] reflectParameterArray = new String[reflectParamTypes.length];
		String reflectParameters = null;
		for (int i = 0; i < tmp.length; i++) {
		  reflectParamTypes[i] = String.class;
		  if ((tmp[i].startsWith("\"")) || (tmp[i].startsWith("'"))) {
		    tmp[i] = tmp[i].substring(1, tmp[i].length() - 1);
		  }
		  else if (bo.getObject(tmp[i]) == null)
		    tmp[i] = "";
		  else {
		    tmp[i] = bo.getString(tmp[i]);
		  }
		  reflectParameterArray[i] = tmp[i];
		  if (reflectParameters == null)
		    reflectParameters = tmp[i];
		  else
		    reflectParameters = (reflectParameters + "," + tmp[i]);
		}
		
		Class<?> c = Class.forName(reflectClassName);
		Method m = c.getMethod(reflectFunctionName, reflectParamTypes);
		String result = "";
		
		if (reflectParameters.equals("")) {
		if ((m.getParameterTypes() == null) || (m.getParameterTypes().length == 0))
			result = (String)m.invoke(c, null);
		else
			result = (String)m.invoke(c, new String[] { "" });
		}
		else{
			result = (String)m.invoke(c, reflectParameterArray);
		}
		
		bo.setAttributeValue(colName, result);
		
    }
	
	
	@Override
	public int getTotalCount() throws Exception {
		return totalCount;
	}
}
