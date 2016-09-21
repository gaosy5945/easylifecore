/**
 * Class <code>BusinessObjectManager</code> 是所有核算对象的管理器
 * 它用来管理<code>com.amarsoft.app.base.businessobject.BusinessObject</code>产生的对象
 * 主要负责从数据库加载数据、更新数据、插入数据等动作. 
 * @since   JDK1.6
 */

package com.amarsoft.app.base.businessobject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.ASValuePool;

public class BusinessObjectManager{
	/**
	 * 定义不同的数据内存对象池，需保存的业务对象
	 */
	protected HashMap<String,List<BusinessObject>> updateObjects=new HashMap<String,List<BusinessObject>>();
	
	/**
	 * 定义不同的数据内存对象池，需删除的业务对象
	 */
	protected HashMap<String,List<BusinessObject>> deleteObjects=new HashMap<String,List<BusinessObject>>();
	
	/**
	 * 定义处理数据对象的“管理器”缓存池
	 * 使用com.amarsoft.are.jbo.BizObjectManager管理器，则该对象中存储该管理器实例化对象
	 */
	protected HashMap<String,BizObjectManager> bizObjectManagers = new HashMap<String,BizObjectManager>();

	/**
	 * 定义数据处理连接，为了兼容JBO基础数据处理结构，此处定义JBOTransaction
	 */
	protected JBOTransaction tx=null;
	
	/**
	 * 管理数据对象数量
	 */
	protected int objectNumber=0;
	/**
	 * 创建一个对象管理器
	 * @return
	 * @throws JBOException
	 * @throws SQLException
	 */
	public static BusinessObjectManager createBusinessObjectManager(){
		BusinessObjectManager businessObjectManager = new BusinessObjectManager();
		return businessObjectManager;
	}
	
	/**
	 * 根据JBOTransaction创建一个对象管理器，事物与JBOTransaction保持一致
	 * @param tx
	 * @return
	 * @throws JBOException
	 * @throws SQLException
	 */
	public static BusinessObjectManager createBusinessObjectManager(JBOTransaction tx){
		BusinessObjectManager businessObjectManager = createBusinessObjectManager();
		businessObjectManager.tx = tx;
		return businessObjectManager;
	}

	/**
	 * 获取变量tx对象
	 * @return JBOTransaction
	 */
	public JBOTransaction getTx() {
		return tx;
	}
	
	/**
	 * 获取数据库连接对象
	 * @return JBOTransaction
	 * @throws JBOException 
	 * @throws SQLException 
	 */
	public Connection getConnection() throws JBOException {
		if(tx!=null){
			BizObjectManager m = JBOFactory.getFactory().getManager("jbo.sys.SYSTEM_SETUP");
			tx.join(m);
			return tx.getConnection(m);
		}
		else{
			return null;
		}
	}
	
	/**
	 * 将传入的BusinessObject对象存入到管理器指定操作方式的内存对象中
	 * @param object
	 * @throws Exception
	 */
	public void updateBusinessObject(BusinessObject businessObject) throws Exception{
		businessObject.generateKey(false);
		String jboClassName = businessObject.getBizClassName();
		ArrayList<BusinessObject> deleteList = (ArrayList<BusinessObject>)deleteObjects.get(jboClassName);
		if(deleteList!=null && deleteList.contains(businessObject)){
			deleteList.remove(businessObject);
		}
		else{
			ArrayList<BusinessObject> list=(ArrayList<BusinessObject>) updateObjects.get(jboClassName);
			if(list==null){
				list=new ArrayList<BusinessObject>();
				updateObjects.put(jboClassName, list);
			}
			if(!list.contains(businessObject)){
				list.add(businessObject);
				objectNumber++;
			}
		}
	}
	
	/**
	 * 将传入的BusinessObject对象存入到管理器指定操作方式的内存对象中
	 * @param operateFlag
	 * @param objectList
	 * @throws Exception
	 */
	public void deleteBusinessObject(BusinessObject businessObject) throws Exception{
		String jboClassName = businessObject.getBizClassName();
		ArrayList<BusinessObject> list = (ArrayList<BusinessObject>)updateObjects.get(jboClassName);
		if(list!=null && list.contains(businessObject)){
			list.remove(businessObject);
		}
		else{
			list=(ArrayList<BusinessObject>) deleteObjects.get(jboClassName);
			if(list==null){
				list=new ArrayList<BusinessObject>();
				deleteObjects.put(jboClassName, list);
			}
			if(!list.contains(businessObject)){
				list.add(businessObject);
				objectNumber++;
			}
		}
	}
	
	/**
	 * 将传入的BusinessObject对象存入到管理器指定操作方式的内存对象中
	 * @param objectList
	 * @throws Exception
	 */
	public void updateBusinessObjects(List<BusinessObject> objectList) throws Exception{
		if(objectList == null) return;
		for(BusinessObject o:objectList){
			updateBusinessObject(o);
		}
	}
	
	/**
	 * 将传入的BusinessObject对象存入到管理器指定操作方式的内存对象中
	 * @param objectList
	 * @throws Exception
	 */
	public void deleteBusinessObjects(List<BusinessObject> objectList) throws Exception{
		if(objectList == null) return;
		for(BusinessObject o:objectList){
			deleteBusinessObject(o);
		}
	}
	
	/**
	 * 根据JBO名称获取BizObjectManager实例
	 * @param objectType
	 * @return
	 * @throws JBOException
	 */
	public BizObjectManager getBizObjectManager(String jboName) throws JBOException{
		BizObjectManager m = null;
		if(bizObjectManagers.get(jboName) == null){
			m = JBOFactory.getFactory().getManager(jboName);
			if(tx != null) tx.join(m);
			bizObjectManagers.put(jboName, m);
		}
		else
			m = (BizObjectManager)bizObjectManagers.get(jboName);
		return m;
	}
	
	public BusinessObject loadRelativeBusinessObject(BusinessObject mainObject,String relativeType) throws Exception{
		List<BusinessObject> a=this.loadRelativeBusinessObjects(mainObject, relativeType);
		if(a.isEmpty()) return null;
		else if(a.size()>1) throw new JBOException("该对象类型【"+mainObject.getBizClassName()+"】的关联对象属性【"+relativeType+"】的数据存在多条！");
		return a.get(0);
	}
	
	public List<BusinessObject> loadRelativeBusinessObjects(BusinessObject mainObject,String relativeType) throws Exception{
		Map<String, Object> relativeTypeConfig = BusinessObjectHelper.getBizClassRelativeType(mainObject.getBizObjectClass(), relativeType);
		String[][] mappingAttributes=(String[][])relativeTypeConfig.get("AttributeMapping");
		Map<String,Object> parameters=new HashMap<String,Object>();
		for(int i=0;i<mappingAttributes.length;i++){
			Object value = null;
			if(mappingAttributes[i][1].equals("ATTRIBUTE")) value = mainObject.getObject(mappingAttributes[i][2]);
			else value=mappingAttributes[i][2];
			parameters.put(mappingAttributes[i][0], value);
		}
		 List<BusinessObject> l = this.simpleLoadBusinessObjects((String)relativeTypeConfig.get("BizObjectClass"), parameters);
		 mainObject.setAttributeValue(relativeType, l);
		 return l;
	}
	
	public BusinessObject keyLoadBusinessObject(String bizObjectClass,Object... keyValues) throws Exception{
		BizObjectClass c=JBOFactory.getBizObjectClass(bizObjectClass);
		String[] keys=c.getKeyAttributes();
		if(keys.length != keyValues.length) throw new JBOException("该对象类型【"+bizObjectClass+"】的主键值数据不正确【"+keyValues+"】！");
		Object[] paramters = new Object[keys.length*2];
		for(int i = 0;i < keys.length; i ++){
			paramters[i*2]=keys[i];
			paramters[i*2+1]=keyValues[i];
		}
		List<BusinessObject> a=this.simpleLoadBusinessObjects(bizObjectClass, paramters);
		if(a.isEmpty()) return null;
		else if(a.size()>1) throw new JBOException("该对象类型【"+bizObjectClass+"】的符合条件【"+keyValues+"】的数据存在多条！");
		return a.get(0);
	}
	
	public BusinessObject loadBusinessObject(String jboName,Object... parameters) throws Exception{
		if(parameters.length == 1) return keyLoadBusinessObject(jboName,parameters);
		List<BusinessObject> a=this.simpleLoadBusinessObjects(jboName, parameters);
		if(a.isEmpty()) return null;
		else if(a.size()>1) throw new JBOException("该对象类型【"+jboName+"】的符合条件【"+parameters+"】的数据存在多条！");
		return a.get(0);
	}
	
	public List<BusinessObject> simpleLoadBusinessObjects(String jboName,Object... parameters) throws Exception{
		String sql="";
		for(int i=0;i<parameters.length-1;i++){
			if(!StringX.isEmpty(sql))sql+=" and ";
			sql+=parameters[i]+"=:"+parameters[i];
			i++;
		}
		return this.loadBusinessObjects(jboName, sql, parameters);
	}
	
	protected List<BusinessObject> loadBusinessObjects(BizObjectQuery query) throws JBOException{
		return loadBusinessObjects(query,0,1000);
	}
	
	public List<BusinessObject> loadBusinessObjects(BizObjectQuery query,int from,int to) throws JBOException{
		query.setFirstResult(from);
		query.setMaxResults(to);
		@SuppressWarnings("unchecked")
		List<BizObject> jboResultSet = query.getResultList(true);
		List<BusinessObject> bizObjectList = new ArrayList<BusinessObject>();
		for(BizObject bo:jboResultSet){
			bizObjectList.add(BusinessObject.convertFromBizObject(bo));
		}
		return bizObjectList;
	}
	
	/**
	 * 根据ObjectType获取JBO的数据结构定义
	 * 根据Where条件和Where条件附带参数从数据库中加载多个数据对象
	 * 并返回多个数据对象的List
	 * @param objectType
	 * @param whereClause
	 * @param parameter
	 * @return List<BusinessObject>
	 * @throws Exception
	 */
	public List<BusinessObject> loadBusinessObjects(String jboClass,String jbosql,Object... parameters) throws Exception{
		BizObjectQuery query = this.getQuery(jboClass, jbosql, parameters);
		return this.loadBusinessObjects(query);
	}
	
	
	public List<BusinessObject> loadBusinessObjects(List<BusinessObject> boList, String relaObjectType,
			String relaWhereClause, ASValuePool rela) throws Exception {

		BizObjectManager m1 = getBizObjectManager(relaObjectType);

		BizObjectQuery q1 = m1.createQuery(relaWhereClause);

		for (BusinessObject bo : boList) {
			for (Object key : rela.getKeys()) {
				String s = rela.getString((String) key);
				if (s.indexOf("${") >= 0)
					q1.setParameter((String) key, bo.getString(s.replace("${", "").replace("}", "")));
				else if (s.indexOf("{#") >= 0)
					q1.setParameter((String) key, bo.getString(s.replace("{#", "").replace("}", "")));
				else
					q1.setParameter((String) key, s);
			}

			List<BizObject> ls = q1.getResultList(true);
			if(ls != null && !ls.isEmpty())
			{
				for(BizObject l:ls)
				{
					bo.appendBusinessObject(relaObjectType,BusinessObject.convertFromBizObject(l));
				}
			}
		}
		return boList;
	}
	
	/**
	 * 执行ＳＱＬ语句，返回List<BusinessObject>
	 * @param sql
	 * @param map  参数
	 * @param sqlca
	 * @return
	 * @throws Exception 
	 */
	public List<BusinessObject> loadBusinessObjects_SQL(String sql,BusinessObject parameter) throws Exception{
		return loadBusinessObjects_SQL("",sql,parameter);
	}
	
	/**
	 * 执行ＳＱＬ语句，返回List<BusinessObject>
	 * @param sql
	 * @param map  参数
	 * @param sqlca
	 * @return
	 * @throws Exception 
	 */
	public List<BusinessObject> loadBusinessObjects_SQL(String objectType,String sql,BusinessObject parameter) throws Exception{
		List<String> paraList=com.amarsoft.app.base.util.StringHelper.getParameterList(sql);
		List<String> valueList = new ArrayList<String>();
		for(String paraID:paraList){
			String value = parameter.getString(paraID);
			if(sql.indexOf("'{#"+paraID+"}%'") > -1)
				value += "%";
			while(sql.indexOf(":{#"+paraID+"}") > -1){
				sql=sql.replaceFirst("\\:\\{#"+paraID+"\\}", "?");
				valueList.add(value);
			}
			while(sql.indexOf("'{#"+paraID+"}'") > -1){
				sql=sql.replaceFirst("'\\{#"+paraID+"\\}'", "?");
				valueList.add(value);
			}
			while(sql.indexOf("'{#"+paraID+"}%'") > -1){
				sql=sql.replaceFirst("'\\{#"+paraID+"\\}%'", "?");
				valueList.add(value);
			}
			while(sql.indexOf("{#"+paraID+"}") > -1){
				sql=sql.replaceFirst("\\{#"+paraID+"\\}", "?");
				valueList.add(value);
			}
			
		}
		
		List<BusinessObject> lst=new ArrayList<BusinessObject>();
		Connection conn = null;
		BizObjectManager manager = JBOFactory.getBizObjectManager("jbo.sys.USER_INFO");
		if(tx != null)
		{
			tx.join(manager);
			conn = tx.getConnection(manager);
		}else
		{
			conn = ARE.getDBConnection(manager.getDatabase());
		}
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			
			ps = conn.prepareStatement(sql);
			for(int i = 0; i < valueList.size();i ++)
			{
				ps.setString(i+1, valueList.get(i));
			}
			rs = ps.executeQuery();
			while(rs.next()){
				BusinessObject bo = null;
				if(StringX.isEmpty(objectType)){
					bo=BusinessObject.createBusinessObject();
				}
				else{
					bo=BusinessObject.createBusinessObject(objectType);
				}
				
				ResultSetMetaData rsm = rs.getMetaData();
				for(int i=1;i<=rsm.getColumnCount();i++){
					String name=rsm.getColumnLabel(i);
					bo.setAttributeValue(name, rs.getObject(name));
				}
				lst.add(bo);
			}
			rs.close();
			
		}catch(Exception ex)
		{
			ARE.getLog().error(sql);
			throw ex;
		}
		finally{
			if(ps != null) ps.close();
			if(rs != null) rs.close();
			if(tx == null || conn != null) conn.close();
		}
		return lst;
	}
	
	/**
	 * 清理管理器中的对象信息
	 * @throws Exception
	 */
	public void clear() throws Exception{
		if(updateObjects!=null) updateObjects.clear();
		if(deleteObjects!=null) deleteObjects.clear();
	}
	
	/**
	 * 执行数据库提交
	 * @throws Exception
	 */
	public void commit() throws Exception{
		this.tx.commit();
		
	}
	
	/**
	 * 执行数据库回滚
	 * @throws Exception
	 */
	public void rollback() throws Exception{
		this.tx.rollback();
	}
	
	/**
	 * 根据内存对象池分别进行不同的数据写入操作
	 * 并将内存对象池中的数据清空
	 * @throws Exception
	 */
	public void updateDB() throws Exception{
		try{
			for(Iterator<String> it=deleteObjects.keySet().iterator();it.hasNext();){
				String jboName = it.next();
				ArrayList<BusinessObject> businessObjects = (ArrayList<BusinessObject>) deleteObjects.get(jboName);
				BizObjectManager m = getBizObjectManager(jboName);
				if(businessObjects != null)
				{
					for(BusinessObject businessobject:businessObjects){
						if(businessobject.getState()==StateBizObject.STATE_NEW){
							continue;
						}
						else m.deleteObject(businessobject);
					}
				}
			}
			deleteObjects.clear();
			
			for(Iterator<String> it=updateObjects.keySet().iterator();it.hasNext();){
				String jboName = it.next();
				ArrayList<BusinessObject> businessObjects = (ArrayList<BusinessObject>) updateObjects.get(jboName);
				BizObjectManager m = getBizObjectManager(jboName);
				if(businessObjects != null)
				{
					for(BusinessObject businessobject:businessObjects){
						m.saveObject(businessobject);
					}
				}
			}
			updateObjects.clear();
			this.bizObjectManagers.clear();
			objectNumber=0;
		}
		catch(Exception e){
			tx.rollback();
			throw e;
		}
	}
	
	public void updateBusinessObjects(List<BusinessObject> list,Object... parameters) throws Exception{
		for(BusinessObject o:list){
			for(int i=0;i<parameters.length-1;i++){
				o.setAttributeValue((String)parameters[i], parameters[i+1]);
				i++;
				this.updateBusinessObject(o);
			}
		}
	}
	
	public BizObjectQuery getQuery(String jboClass,String jbosql,Object... parameters) throws JBOException{
		BizObjectManager manager = JBOFactory.getBizObjectManager(jboClass);
		if(tx!=null)tx.join(manager);
		
		for(int i=0;i<parameters.length-1;i++){
			String parameterName=(String)parameters[i];
			Object value=parameters[i+1];
			if(value instanceof Object[]){
				Object[] values = (Object[])value;
				String insql="";
				for(int j=0;j<values.length;j++){
					insql +=","+":SYS_GEN_"+parameterName+"_"+j;
				}
				if(insql.length()>0) insql=insql.substring(1);
				jbosql = jbosql.replaceAll(":"+parameterName, insql);
			}
			i++;
		}
		BizObjectQuery query = manager.createQuery(jbosql);
		
		for(int i=0;i<parameters.length-1;i++){
			String parameterName=(String)parameters[i];
			Object value=parameters[i+1];
			if(value instanceof Object[]){
				Object[] values = (Object[])value;
				for(int j=0;j<values.length;j++){
					String parameterName_IN ="SYS_GEN_"+parameterName+"_"+j;
					query.setParameter(parameterName_IN, (String)values[j]);
				}
			}
			else{
				DataElement dataElement = new DataElement(parameterName);
				dataElement.setValue(value);
				query.setParameter(dataElement);
			}
			i++;
		}
		return query;
	}
	
	/**
	 * 获取管理器正在管理的对象数量
	 * @return
	 */
	public int getObjectNumber(){
		return objectNumber;
	}
}
