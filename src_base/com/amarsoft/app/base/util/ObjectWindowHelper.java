package com.amarsoft.app.base.util;

import java.io.File;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.ql.DefaultParser;
import com.amarsoft.are.jbo.ql.Element;
import com.amarsoft.are.jbo.ql.JBOClass;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONElement;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.are.util.json.JSONException;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASDataWindow;
import com.amarsoft.awe.dw.ASObjectModel;
import com.amarsoft.awe.dw.ASObjectWindow;
import com.amarsoft.awe.dw.datamodel.CatalogModel;
import com.amarsoft.awe.util.ObjectConverts;
import com.amarsoft.dict.als.cache.AWEDataWindowCache;

public class ObjectWindowHelper {
	public static final String OBJECTWINDOW_SUBINFOOW="SubInfoOW";
	public static final String OBJECTWINDOW_SUBLISTOW="SubListOW";
	public static final String OBJECTWINDOW_SUBPAGE="SubPage";
	public static final String OBJECTWINDOW_XML="XML";
	
	/**
	 * 根据显示模板获得扩展后的BizObjectClass
	 * @param dataObject
	 * @return
	 * @throws JBOException
	 */
	public static BizObjectClass getBizObjectClass(ASDataObject dataObject) throws JBOException {
		BizObjectClass bizObjectClass = JBOFactory.getBizObjectClass(dataObject.getJboClass());
		//获得所有的字段
		String[] attributes = dataObject.getJboAttributes();
		List<DataElement> extendedAttributes = new ArrayList<DataElement>();
		for(int i=0;i<attributes.length;i++){
			if(bizObjectClass.indexOfAttribute(attributes[i])==-1){
				extendedAttributes.add(new DataElement(attributes[i]));
			}
		}
		DataElement[] dataElementArray=new DataElement[extendedAttributes.size()];
		for(int i=0;i<extendedAttributes.size();i++){
			dataElementArray[i]=extendedAttributes.get(i);
		}
		bizObjectClass = bizObjectClass.extend(dataElementArray);
		return bizObjectClass;
	}

	/**
	 * 获取ow的传入参数值
	 * @param doTemp
	 * @param parameterID
	 * @return
	 * @throws Exception 
	 */
	public static String getDataObjectParameter(ASDataObject doTemp,String parameterID) throws Exception{
		parameterID=parameterID.toUpperCase();
		BusinessObject map = getDataObjectParameters(doTemp);
		if(map==null) return null;
		return map.getString(parameterID);
	}
	
	/**
	 * 获取ow的传入参数值
	 * @param doTemp
	 * @param parameterID
	 * @return
	 * @throws Exception 
	 */
	public static BusinessObject getDataObjectParameters(ASDataObject doTemp) throws Exception{
		BusinessObject doTempParameterMap = BusinessObject.createBusinessObject();
		List<DataElement> doTempParameterList = doTemp.getParameters();
		if(doTempParameterList==null||doTempParameterList.isEmpty()) return doTempParameterMap;
		for(DataElement parameter:doTempParameterList){
			doTempParameterMap.setAttributeValue(parameter.getName(), parameter.getValue());
		}
		return doTempParameterMap;
	}
	
	/**
	 * 获取ow的传入参数值
	 * @param doTemp
	 * @param parameterID
	 * @return
	 */
	public static String getObjectWindowName(ASDataObject doTemp){
		String dwname = doTemp.getCustomProperties().getProperty("DWName");
		if(StringX.isEmpty(dwname)) return "0";
		return dwname;
	}
	
	/**
	 * 得到表单名称
	 * @param dataObject
	 * @return
	 */
	public static String getObjectWindowFormName(ASDataObject dataObject) {
		return "myiframe"+getObjectWindowName(dataObject);
	}
	
	public static void setObjectWindowName(ASDataObject doTemp, String dwname) throws Exception {
		doTemp.getCustomProperties().setProperty("DWName", dwname);
		int dwIndex = Integer.valueOf(dwname);
		String dwCountString=doTemp.getCurPage().getAttribute("SYS_DWCOUNT");
		if(StringX.isEmpty(dwCountString))dwCountString="0";
		if(dwIndex>=Integer.valueOf(dwCountString)){
			doTemp.getCurPage().setAttribute("SYS_DWCOUNT", dwname);
		}
	}
	
	/**
	 * 使用此方法实例化一个ObjectModel，对原有的一些功能缺陷进行修复，并增加一些功能，如：支持字段别名，支持多个对象类型操作等
	 * @param doTemp
	 * @param parameterID
	 * @return
	 * @throws Exception 
	 */
	public static ASObjectModel createObjectModel(String templeteNo,BusinessObject inputParameter,Page curPage) throws Exception{
		ASObjectModel doTemp = new ASObjectModel(templeteNo);
		doTemp.setCurPage(curPage);
		doTemp.init();
		CatalogModel objCatalogModel = AWEDataWindowCache.getInstance().getCatalogModel(doTemp.getDONO());
		doTemp.setJboFrom(objCatalogModel.getJboFrom());
		//设置参数
		ObjectWindowHelper.setDataObjectParameters(doTemp, inputParameter);
		
		if(StringX.isEmpty(doTemp.getBusinessProcess())){
			doTemp.setBusinessProcess("com.amarsoft.app.als.awe.ow.ALSBusinessProcess");;
		}
		initCustomerProperties(doTemp);
		
		for(int i=0;i<doTemp.Columns.size();i++){
			ASColumn column = doTemp.getColumn(i);
			String editSource = column.getAttribute("COLEDITSOURCE");
			if(editSource!= null){
				editSource = StringHelper.replaceString(editSource, inputParameter);//然后使用dw传入参数，这个顺序不能调整，因为新增对象时dw传入的参数为空，但对象流水是有值的。
				column.setAttribute("COLEDITSOURCE", editSource);
			}
		}
		doTemp.setLockCount(0);
		return doTemp;
	}
	
	/**
	 * 设置自定义参数
	 * @param doTemp
	 * @throws SQLException 
	 * @throws JBOException 
	 */
	private static void initCustomerProperties(ASObjectModel doTemp) throws Exception{
		//1.统计可更新字段，需要重新获取，因为在ASColumn中不包含属性“ISUPDATE”
		doTemp.getCustomProperties().put("IsUpdateColums","");
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(null);
		List<BusinessObject> columnList = bomanager.loadBusinessObjects("jbo.ui.system.DATAOBJECT_LIBRARY", " DONO=:DONO","DONO",doTemp.getDONO());
		for(BusinessObject column:columnList){
			if("1".equals(column.getString("ISUPDATE"))){
				String isUpdateColums = (String)doTemp.getCustomProperties().get("IsUpdateColums");
				isUpdateColums+=column.getString("COLNAME")+",";
				doTemp.getCustomProperties().put("IsUpdateColums",isUpdateColums);
			}
		}
		
		//2.解析子对象字段
		BusinessObject temp = BusinessObject.createBusinessObject();
		for(int i=0;i<doTemp.Columns.size();i++){
			ASColumn column = doTemp.getColumn(i);
			String isinuse=column.getAttribute("ISINUSE");
			if(StringX.isEmpty(isinuse)||!isinuse.equals("1")) continue;
			String visible=column.getAttribute("COLVISIBLE");
			if(StringX.isEmpty(visible)||!visible.equals("1")) continue;
			String colEditSourceType = column.getAttribute("COLEDITSOURCETYPE");
			String colEditSource = column.getAttribute("COLEDITSOURCE");
			if(StringX.isEmpty(colEditSourceType)) continue;
			if(!colEditSourceType.startsWith("Sub"))continue;
			if(StringX.isEmpty(colEditSource)) continue;
			column.setAttribute("COLSPAN", "2");
			BusinessObject subObjects = temp.getBusinessObject(colEditSourceType);
			if(subObjects==null){
				subObjects = BusinessObject.createBusinessObject();
				temp.setAttributeValue(colEditSourceType, subObjects);
			}
			BusinessObject parameters = StringHelper.stringToBusinessObject(colEditSourceType,colEditSource, "&", "=");
			subObjects.setAttributeValue(column.getAttribute("COLNAME"),parameters);
		}
		
		String[] keys = temp.getAttributeIDArray();
		for(String key:keys){
			if(temp.hasSubBizObject(key))
			{
				doTemp.getCustomProperties().put(key,temp.getBusinessObject(key).toJSONString());
			}
		}
	}
	
	/**
	 * 使用此方法实例化一个ObjectModel，对原有的一些功能缺陷进行修复，并增加一些功能，如：支持字段别名，支持多个对象类型操作等
	 * @param templetNo
	 * @param style
	 * @param readOnly
	 * @param inputParameter
	 * @param curPage
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static ASObjectWindow createObjectWindow(String templetNo,String dwname,String style,String readOnly,BusinessObject inputParameter,Page curPage,HttpServletRequest request) throws Exception{
		ASObjectWindow dwTemp=null;
		if("2".equals(style)){
			dwTemp = ObjectWindowHelper.createObjectWindow_Info(templetNo,dwname,inputParameter, curPage, request);
		}
		else {
			dwTemp = ObjectWindowHelper.createObjectWindow_List(templetNo,dwname,inputParameter, curPage, request);
		}
		if("All".equalsIgnoreCase(readOnly))
			readOnly="0";
		else if("ReadOnly".equalsIgnoreCase(readOnly))
			readOnly="1";
		else readOnly="0";
		dwTemp.ReadOnly=readOnly;
		return dwTemp;
	}
	
	public static ASObjectWindow createObjectWindow(String templetNo,String style,String readOnly,BusinessObject inputParameter,Page curPage,HttpServletRequest request) throws Exception{
		return ObjectWindowHelper.createObjectWindow(templetNo, "0", style, readOnly, inputParameter, curPage, request);
	}
	
	/**
	 * 使用此方法实例化一个ObjectModel，对原有的一些功能缺陷进行修复，并增加一些功能，如：支持字段别名，支持多个对象类型操作等
	 * @param doTemp
	 * @param parameterID
	 * @return
	 * @throws Exception 
	 */
	public static ASObjectWindow createObjectWindow_Info(ASObjectModel doTemp,Page curPage,HttpServletRequest request) throws Exception{
		doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator");
		ASObjectWindow dwTemp = new ASObjectWindow(curPage,doTemp,request);
		dwTemp.Style="2";      //设置为freeform风格
		doTemp.getCustomProperties().setProperty("DWSTYLE", dwTemp.Style);
		String dwname = ObjectWindowHelper.getObjectWindowName(doTemp);
		ObjectWindowHelper.setObjectWindowName(doTemp,dwname);
		return dwTemp;
	}
	
	/**
	 * 使用此方法实例化一个ObjectModel，对原有的一些功能缺陷进行修复，并增加一些功能，如：支持字段别名，支持多个对象类型操作等
	 * @param doTemp
	 * @param parameterID
	 * @return
	 * @throws Exception 
	 */
	public static ASObjectWindow createObjectWindow_List(ASObjectModel doTemp,Page curPage,HttpServletRequest request) throws Exception{
		doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
		ASObjectWindow dwTemp = new ASObjectWindow(curPage,doTemp,request);
		ObjectWindowHelper.setObjectWindowParameters(dwTemp, ObjectWindowHelper.getDataObjectParameters(doTemp));
		dwTemp.Style="1";      //设置为grid风格
		dwTemp.setPageSize(20);
		doTemp.getCustomProperties().setProperty("DWSTYLE", dwTemp.Style);
		String dwname = ObjectWindowHelper.getObjectWindowName(doTemp);
		ObjectWindowHelper.setObjectWindowName(doTemp,dwname);
		return dwTemp;
	}
	
	/**
	 * 使用此方法实例化一个ObjectModel，对原有的一些功能缺陷进行修复，并增加一些功能，如：支持字段别名，支持多个对象类型操作等
	 * @param doTemp
	 * @param parameterID
	 * @return
	 * @throws Exception 
	 */
	public static ASObjectWindow createObjectWindow_Info(String templeteNo,String dwname,BusinessObject inputParameter,Page curPage,HttpServletRequest request) throws Exception{
		ASObjectModel doTemp = createObjectModel(templeteNo,inputParameter,curPage);
		doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSInfoHtmlGenerator");
		ASObjectWindow dwTemp = new ASObjectWindow(curPage,doTemp,request);
		dwTemp.Style="2";      //设置为freeform风格
		doTemp.getCustomProperties().setProperty("DWSTYLE", dwTemp.Style);
		String rightType = inputParameter.getString("RightType");
		if("ReadOnly".equalsIgnoreCase(rightType))dwTemp.ReadOnly="1";
		else{
			rightType="All";
		}
		inputParameter.setAttributeValue("RightType", rightType);
		ObjectWindowHelper.setObjectWindowParameters(dwTemp, inputParameter);
		
		if(StringX.isEmpty(dwname)) dwname="0";
		ObjectWindowHelper.setObjectWindowName(doTemp, dwname);
		return dwTemp;
	}
	
	public static ASObjectWindow createObjectWindow_Info(String templeteNo,BusinessObject inputParameter,Page curPage,HttpServletRequest request) throws Exception{
		return ObjectWindowHelper.createObjectWindow_Info(templeteNo, "0", inputParameter, curPage, request);
	}
	
	public static ASObjectWindow createObjectWindow_List(String templeteNo,BusinessObject inputParameter,Page curPage,HttpServletRequest request) throws Exception{
		return ObjectWindowHelper.createObjectWindow_List(templeteNo, "0", inputParameter, curPage, request);
	}
	
	/**
	 * 使用此方法实例化一个ObjectModel，对原有的一些功能缺陷进行修复，并增加一些功能，如：支持字段别名，支持多个对象类型操作等
	 * @param doTemp
	 * @param parameterID
	 * @return
	 * @throws Exception 
	 */
	public static ASObjectWindow createObjectWindow_List(String templeteNo,String dwname,BusinessObject inputParameter,Page curPage,HttpServletRequest request) throws Exception{
		ASObjectModel doTemp = createObjectModel(templeteNo,inputParameter,curPage);
		doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
		ASObjectWindow dwTemp = new ASObjectWindow(curPage,doTemp,request);
		dwTemp.Style="1";      //设置为grid风格
		String rightType = inputParameter.getString("RightType");
		if("ReadOnly".equalsIgnoreCase(rightType))dwTemp.ReadOnly="1";
		else dwTemp.ReadOnly="0";
		doTemp.getCustomProperties().setProperty("DWSTYLE", dwTemp.Style);
		ObjectWindowHelper.setObjectWindowParameters(dwTemp, inputParameter);
		int pageSize = inputParameter.getInt("PageSize");
		if(pageSize==0) pageSize=15;
		dwTemp.setPageSize(pageSize);
		String multipleSelect = inputParameter.getString("MultiSelect");
		if(!StringX.isEmpty(multipleSelect)&&multipleSelect.equals("Y")){
			dwTemp.MultiSelect = true;
		}
		
		if(StringX.isEmpty(dwname)) dwname="0";
		ObjectWindowHelper.setObjectWindowName(doTemp, dwname);
		return dwTemp;
	}
	
	public static boolean isUpdateColumn(ASDataObject doTemp,String columnName){
		String isUpdateColums = (String)doTemp.getCustomProperties().get("IsUpdateColums");
		if(isUpdateColums==null) return false;
		return StringHelper.contains(isUpdateColums, columnName);
	}
	
	/**
	 * 获取一个显示模板中，涉及的多个BizObjectClass名称和别名
	 * @param doTemp
	 * @return
	 * @throws JBOException
	 */
	public static Map<String,String> getJBOClassMap(ASDataObject doTemp) throws JBOException{
		Map<String,String> jboClassMap = new HashMap<String,String>();
		
		DefaultParser parser = new DefaultParser();
		String sql =getJBOQuerySql(doTemp);
		parser.parse(JBOFactory.getBizObjectClass(doTemp.getJboClass()), sql);
		Element[] elementArray = parser.getElementSequence();
		for(Element element:elementArray){
			if(element instanceof JBOClass){
				jboClassMap.put(((JBOClass) element).getAlias(), ((JBOClass) element).getName());
			}
		}
		return jboClassMap; 
	}
	
	/**
	 * 获取一个显示模板中，需要更新的多个BizObjectClass名称和别名
	 * @param dataObject
	 * @return
	 * @throws Exception
	 */
	public static Map<String,String> getNeedUpdateJBOClass(ASDataObject dataObject) throws Exception{
		Map<String, String> needUpdateJBOClassMap = new HashMap<String,String>();
		
		Map<String, String> jboClassMap = ObjectWindowHelper.getJBOClassMap(dataObject);
		for(Object o:dataObject.Columns){
			ASColumn ascolumn = (ASColumn)o;
			String jboClassAlias = ascolumn.getAttribute("COLTABLENAME");
			boolean isUpdate = ObjectWindowHelper.isUpdateColumn(dataObject, ascolumn.getAttribute("COLNAME"));
			if(StringX.isEmpty(jboClassAlias)) continue;
			if(jboClassAlias.equalsIgnoreCase("O"))  continue;
			if(!isUpdate)continue;
			needUpdateJBOClassMap.put(jboClassAlias, jboClassMap.get(jboClassAlias));
		}
		checkKey(dataObject,needUpdateJBOClassMap);
		return needUpdateJBOClassMap;
	}
	
	/**
	 * 检查需要更新的BizObjectClass是否配置了主键
	 * @param dataObject
	 * @param needUpdateJBOClassMap
	 * @return
	 * @throws Exception
	 */
	private static boolean checkKey(ASDataObject dataObject,Map<String, String> needUpdateJBOClassMap) throws Exception{
		for(Iterator<String> it=needUpdateJBOClassMap.keySet().iterator();it.hasNext();){
			String jboClassAlias = it.next();
			String jboClassName = needUpdateJBOClassMap.get(jboClassAlias);
			String[] keyAttributes = JBOFactory.getBizObjectClass(jboClassName).getKeyAttributes();
			if(keyAttributes==null||keyAttributes.length==0){
				throw new Exception("JBOClass={"+jboClassName+"}未定义主键，不能有字段设置为可更新！");
			}
			
			for(String keyAttribute:keyAttributes){
				boolean keyExists = false;
				for(Object o:dataObject.Columns){
					ASColumn ascolumn = (ASColumn)o;
					String jboClassAlias_T = ascolumn.getAttribute("COLTABLENAME");
					if(StringX.isEmpty(jboClassAlias_T)) continue;
					String attributeID = ascolumn.getAttribute("COLACTUALNAME");
					if(!jboClassAlias.equals(jboClassAlias_T)) continue;
					if(!attributeID.equalsIgnoreCase(keyAttribute)) continue;
					
					boolean isUpdate = ObjectWindowHelper.isUpdateColumn(dataObject, ascolumn.getAttribute("COLNAME"));
					if(!isUpdate)continue;
					
					keyExists=true;
					break;
				}
				if(!keyExists){
					throw new Exception("DONO={"+dataObject.getDONO()+"}中，JBOClassName={"+jboClassName+"}的主键未定义！");
				}
			}
		}
		return true;
	}
	
	/**
	 * 获取DataObject的JBO查询语句，原有功能不支持别名定义，建议使用此方法
	 * @param doTemp
	 * @return
	 */
	public static String getJBOQuerySql(ASDataObject doTemp){
	    String jboQuerySql = getJBOQuerySql_Where(doTemp);
	    jboQuerySql+=getJBOQuerySql_OrderGroup(doTemp);
		return jboQuerySql;
	}
	
	/**
	 * 获取DataObject的JBO查询语句，原有功能不支持别名定义，建议使用此方法
	 * @param doTemp
	 * @return
	 */
	public static String getJBOQuerySql_OrderGroup(ASDataObject doTemp){
	    String jboQuerySql = "";

	    String jboGroup = doTemp.getJboGroup();//objCatalogModel.getJboGroup();
	    if (!StringX.isEmpty(jboGroup)){
	    	jboQuerySql += (" group by " + jboGroup);
	    }
	    String jboOrder = doTemp.getJboOrder();//objCatalogModel.getJboOrder();
	    if (!StringX.isEmpty(jboOrder)){
	    	jboQuerySql += (" order by " +jboOrder);
	    }
		return jboQuerySql;
	}
	
	/**
	 * 获取DataObject的JBO查询语句，原有功能不支持别名定义，建议使用此方法
	 * @param doTemp
	 * @return
	 */
	public static String getJBOQuerySql_Where(ASDataObject doTemp){
		String[] functionColumnArray = doTemp.getVirtualFields();
		String jboQuerySql = "";
		String jboSelect="";
		for(Object column:doTemp.Columns){
			ASColumn ascolumn =(ASColumn) column;
			String tableName = ascolumn.getAttribute("COLTABLENAME");
			String colActualName = ascolumn.getAttribute("COLACTUALNAME");
			String colName = ascolumn.getAttribute("COLNAME");
			
			if(functionColumnArray.length>0){
				boolean functionFlag = false;
				for(String functionColumn:functionColumnArray){
					if(colName.equals(functionColumn)){
						functionFlag=true;
						break;
					}
				}
				if(functionFlag) continue;
			}
			if(!StringX.isEmpty(tableName)){
				colActualName=tableName+"."+colActualName;
			}
			if(!"o".equalsIgnoreCase(tableName)){
				colName="v."+colName;
				jboSelect+= ","+colActualName+" as "+ colName ;
			}
			else jboSelect+= ","+colActualName;
		}
		if(jboSelect.startsWith(",")) jboSelect=jboSelect.substring(1);
		
		jboSelect = jboSelect.replaceAll(doTemp.getJboClass(), "o");//将主对象替换为O
		jboQuerySql = "select " + jboSelect;
		
		String fromSql = doTemp.getJboFrom();//objCatalogModel.getJboFrom();
		jboQuerySql += " from " + fromSql;
		
		//String jboWhere = doTemp.getJboWhere();//objCatalogModel.getJboWhere();
		String jboWhere = doTemp.getCustomProperties().getProperty("JBOWhereClause");
		if (StringX.isEmpty(jboWhere)){
			jboWhere = doTemp.getJboWhere();
		}
	    if (StringX.isEmpty(jboWhere)){
	      jboWhere = " 1=1 ";
	    }
	    jboQuerySql = jboQuerySql + " where " + jboWhere;
		return jboQuerySql;
	}

	public static void setObjectWindowParameters(ASDataWindow dataWindow,
			Map<String, Object> parameters) {
		for(String key :parameters.keySet()){
			Object value = parameters.get(key);
			dataWindow.setParameter(key, (String)value);
		}
		dataWindow.getDataObject().getParameters().clear();
		//把参数给DataObject，在生成HTML前就要用到这些参数。
		dataWindow.getDataObject().getParameters().addAll(dataWindow.getParameters());
	}
	
	public static void setObjectWindowParameters(ASDataWindow dataWindow,BusinessObject parameters) throws JBOException {
		setObjectWindowParameters(dataWindow,parameters.convertToMap());
	}
	
	public static void setDataObjectParameters(ASDataObject dataObject,BusinessObject parameters) throws JBOException {
		String[] attributes=parameters.getAttributeIDArray();
		for(String key :attributes){
			Object value = parameters.getObject(key);
			DataElement parameter = new DataElement(key);
			parameter.setValue(value);
			dataObject.getParameters().add(parameter);
		}
	}
	
	/**
	 * 生成客户端OW的元数据定义
	 * @param doTemp
	 * @return
	 * @throws JSONException
	 * @throws Exception
	 */
	public static String getDWMetaJSONString(ASDataObject doTemp) throws JSONException, Exception{
		BusinessObject dw = BusinessObject.createBusinessObject();
		String dwname = ObjectWindowHelper.getObjectWindowName(doTemp);
		dw.setAttributeValue("DWNAME", dwname);
		dw.setAttributeValue("JBOCLASS", doTemp.getJboClass());
		dw.setAttributeValue("DONO", doTemp.getDONO());
		
		String dwstyle = doTemp.getCustomProperties().getProperty("DWSTYLE");
		dw.setAttributeValue("DWSTYLE", dwstyle);
		
		String columnNameString="";
		for(int i=0;i<doTemp.Columns.size();i++){
			ASColumn column = doTemp.getColumn(i);
			String columnName = column.getItemName();
			if(columnNameString.length()==0) columnNameString+=columnName;
			else  columnNameString+=","+columnName;
			BusinessObject columnObject = BusinessObject.createBusinessObject();
			columnObject.setAttributeValue("COLUMNNAME", columnName);
			columnObject.setAttributeValue("COLUMNHEADER", doTemp.getColumnAttribute(columnName,"COLHEADER"));
			columnObject.setAttributeValue("COLUMNINDEX", column.getAttribute("COLINDEX"));
			columnObject.setAttributeValue("COLINNERBTEVENT", column.getAttribute("COLINNERBTEVENT"));
			columnObject.setAttributeValue("COLREADONLY", column.getAttribute("COLREADONLY"));
			dw.setAttributeValue("COLUMN_ARRAY_"+columnName.toUpperCase(), columnObject);
		}
		dw.setAttributeValue("DWCOLUMNS", columnNameString);
		dw.setAttributeValue("SERIALIZED_ASD", doTemp.getSerializableName());
		String serialID=saveObjectWindowToComponent(doTemp);
		dw.setAttributeValue("SERIALIZED_ASDFULL", serialID);
		return dw.toJSONString();
	}
	
	/**
	 * 生成业务对象的客户端串，objectwindow客户端展现和操作使用
	 * @param bo
	 * @return
	 * @throws Exception
	 */
	public static String generateClientObjectData(ASDataObject doTemp,BusinessObject bo) throws Exception {
		JSONObject o = bo.toJSONObject();
		o.appendElement(JSONElement.valueOf("SerialedString",ObjectConverts.getString(bo)));//
		o.appendElement(JSONElement.valueOf("ClientStatus","1"));
		return JSONEncoder.encode(o);
	}
	
	/**
	 * 不区分大小写，获取字段定义
	 * @param doTemp
	 * @param columnName
	 * @return
	 * @throws Exception
	 */
	public static ASColumn getOWColumn(ASDataObject doTemp,String columnName) throws Exception {
		@SuppressWarnings("unchecked")
		Vector<ASColumn> columns=doTemp.Columns;
		for(ASColumn column:columns){
			if(column.getAttribute("COLNAME").equalsIgnoreCase(columnName))
				return column;
		}
		return null;
	}
	
	public static String saveObjectWindowToComponent(ASDataObject doTemp) throws Exception{
		String dwname = ObjectWindowHelper.getObjectWindowName(doTemp);
		String id =doTemp.getSerializableName()+"-"+dwname;
		ObjectConverts.saveObject(new File(Component.getDWTmpPath(id)), doTemp);
		doTemp.getCurPage().getCurComp().addDW(id);
		return id;
	}
	
	public static ASDataObject getObjectWindowFromComponent(String id) throws Exception{
		return Component.getDataObject(id);
	}
	
	/**
	 * 根据JSON串创建一个对象
	 * @param jsonObject
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject createBusinessObject_JSON(JSONObject jsonObject)
			throws Exception {
		BusinessObject businessObject = null;

		String objectType = (String) jsonObject.getValue("ObjectType");
		String jboClassName = (String) jsonObject.getValue("JBOClass");
		if (StringX.isEmpty(jboClassName))
			jboClassName = objectType;
		String serializedObjectString = (String) jsonObject
				.getValue("SerialedString");

		if (!StringX.isEmpty(serializedObjectString)) {
			businessObject = (BusinessObject) ObjectConverts
					.getObject(serializedObjectString);
		} else {
			if (!StringX.isEmpty(jboClassName)) {
				businessObject = BusinessObject
						.createBusinessObject(jboClassName);
			} else {
				if (!StringX.isEmpty(objectType)) {
					businessObject = BusinessObject
							.createBusinessObject(objectType);
				} else {
					businessObject = BusinessObject.createBusinessObject();
				}
			}
		}

		String objectNo = (String) jsonObject.getValue("ObjectNo");
		if (!StringX.isEmpty(objectNo)) {
			businessObject.setKey(objectNo);
		}
		Integer state = (Integer) jsonObject.getValue("State");
		if (state != null) {
			businessObject.changeState(state.byteValue());
		}

		Object values = jsonObject.getValue("Attributes");
		if (values instanceof JSONObject) {
			JSONObject attributesJSONObject = (JSONObject) jsonObject
					.getValue("Attributes");
			if (attributesJSONObject != null) {
				for (int i = 0; i < attributesJSONObject.size(); i++) {
					com.amarsoft.are.lang.Element attribute = attributesJSONObject
							.get(i);
					String attributeID = attribute.getName();
					Object attributeValue = attribute.getValue();
					if (attributeValue instanceof JSONObject) {
						JSONObject arrayJSONObject = (JSONObject) attributeValue;

						List<BusinessObject> list = new ArrayList<BusinessObject>();
						for (int j = 0; j < arrayJSONObject.size(); j++) {
							JSONObject attributeObjectJSON = (JSONObject) arrayJSONObject
									.getValue(j);

							if (attributeObjectJSON == null)
								continue;

							list.add(createBusinessObject_JSON(attributeObjectJSON));
						}

						businessObject.setAttributeValue(attributeID, list);
					} else {

						businessObject.setAttributeValue(attributeID,
								attributeValue);
					}
				}
			}
		}
		return businessObject;
	}
	
}
