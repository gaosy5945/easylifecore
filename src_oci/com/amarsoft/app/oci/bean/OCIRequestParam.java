package com.amarsoft.app.oci.bean;

import java.util.HashMap;
import java.util.Map;
import java.util.zip.DataFormatException;

import com.amarsoft.app.oci.MessageConstants;
import com.amarsoft.app.oci.OCIConfig;


/**
 * <p>
 * 作为客户端调用实时接口的外部API的参数对象
 * </p>
 * @author xjzhao
 */

public class OCIRequestParam {
	private Map<String, String> defaultValueMap; // 保存默认值的Map
	private Map<String, String> whereSqlMap; // 保存SQL的Map

	public OCIRequestParam() {
		this.defaultValueMap = new HashMap<String, String>();
		this.whereSqlMap = new HashMap<String, String>();
	}

	/**
	 * 添加一个默认参数
	 * @param paramName
	 *            默认参数名
	 * @param paramValue
	 *            参数值
	 */
	public void putDefaultValue(String paramName, String paramValue) {
		defaultValueMap.put(paramName, paramValue);
	}

	/**
	 * 添加一个where条件
	 * 
	 * @param messageId
	 *            消息ID
	 * @param wheresql
	 *            消息sql对应的where条件
	 */
	public void putWhereSql(String messageId, String wheresql) {
		whereSqlMap.put(messageId, wheresql);
	}

	/**
	 * 获得已添加的默认值
	 * 
	 * @param paramName
	 *            默认参数名
	 * @return 参数值
	 */
	public String getDefaultValue(String paramName) {
		return defaultValueMap.get(paramName);
	}

	/**
	 * 获得已添加的where条件
	 * 
	 * @param messageId
	 *            消息ID
	 * @return where条件
	 */
	public String getWhereSql(String messageId) {
		return whereSqlMap.get(messageId);
	}

	/**
	 * 移除已添加的默认值参数
	 * 
	 * @param paramName
	 *            参数名
	 * @return 被移除的参数值
	 */
	public String removeDefaultValue(String paramName) {
		return defaultValueMap.remove(paramName);
	}

	/**
	 * 移除已添加的where条件
	 * 
	 * @param messageId
	 *            消息ID
	 * @return 被移除的where条件
	 */
	public String removeWhereSql(String messageId) {
		return whereSqlMap.remove(messageId);
	}

	/**
	 * 清空所有默认参数值
	 */
	public void clearDefaultValue() {
		defaultValueMap.clear();
	}

	/**
	 * 清空所有where条件
	 */
	public void clearWhereSql() {
		whereSqlMap.clear();
	}

	public Map<String, String> getDefaultValueMap() {
		return this.defaultValueMap;
	}

	public Map<String, String> getWhereSqlMap() {
		return this.whereSqlMap;
	}

	private void checkMessage(Message msg) throws DataFormatException {
		if (msg != null) {
			if (msg.getSelectSQL().length() > 0) { // 配置了selectSql，校验whereSqlMap
				if (whereSqlMap.get(msg.getId()) == null) { // 没有传wheresql
					String mess = "Message(Id:" + msg.getId() + " Description:"
							+ msg.getDescription() + ")设置了Sql语句但没有传Where条件";
					throw new DataFormatException(mess);
				}
			}
			for (Field f : msg.getFields()) {
				String refMsgName = null;
				if (f.getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)) {
					refMsgName = f.getObjectName();
				} else if (f.getDataType().equals(
						MessageConstants.DATA_TYPE_ARRAY)) {
					refMsgName = f.getArrayName();
				} else { // 基本类型
					if (f.getValueSource().equals("Default")
							&& f.getIsRequire().equals("Y")) {
						String defValue = f.getDefaultValue().trim();
						int index = defValue.indexOf("#Constants.");
						if (index > -1) {
							String paramName = defValue.substring("#Constants."
									.length());
							if (defaultValueMap.get(paramName) == null) { // 没有传参数
								String mess = "Message(Id:" + msg.getId()
										+ " Description:"
										+ msg.getDescription() + ")中，字段["
										+ f.getFieldTag() + f.getDescription()
										+ "]设成默认值填充，但没有被赋值";
								throw new DataFormatException(mess);
							}
						}
					}
				}
				if (refMsgName != null) { // 关联其他message
					Message refMsg = null;
					try {
						refMsg = OCIConfig.getMessageByID(refMsgName);
					} catch (Exception e) {
						e.printStackTrace();
					}
					checkMessage(refMsg);
				}
			}
		}
	}

	/**
	 * <p>
	 * 作为客户端时对传入参数校验
	 * </p>
	 * 
	 * @param tran
	 * @throws DataFormatException
	 */
	public void checkParam(OCITransaction tran) throws DataFormatException {
		if (OCIConfig.getProperty("IsInUse", true)) {
			for (String key : tran.getIMessages().keySet())
				checkMessage(tran.getIMessage(key));
		}
	}
}
