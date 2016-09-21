package com.amarsoft.app.oci.bean;

import java.util.HashMap;
import java.util.Map;
import java.util.zip.DataFormatException;

import com.amarsoft.app.oci.MessageConstants;
import com.amarsoft.app.oci.OCIConfig;


/**
 * <p>
 * ��Ϊ�ͻ��˵���ʵʱ�ӿڵ��ⲿAPI�Ĳ�������
 * </p>
 * @author xjzhao
 */

public class OCIRequestParam {
	private Map<String, String> defaultValueMap; // ����Ĭ��ֵ��Map
	private Map<String, String> whereSqlMap; // ����SQL��Map

	public OCIRequestParam() {
		this.defaultValueMap = new HashMap<String, String>();
		this.whereSqlMap = new HashMap<String, String>();
	}

	/**
	 * ���һ��Ĭ�ϲ���
	 * @param paramName
	 *            Ĭ�ϲ�����
	 * @param paramValue
	 *            ����ֵ
	 */
	public void putDefaultValue(String paramName, String paramValue) {
		defaultValueMap.put(paramName, paramValue);
	}

	/**
	 * ���һ��where����
	 * 
	 * @param messageId
	 *            ��ϢID
	 * @param wheresql
	 *            ��Ϣsql��Ӧ��where����
	 */
	public void putWhereSql(String messageId, String wheresql) {
		whereSqlMap.put(messageId, wheresql);
	}

	/**
	 * �������ӵ�Ĭ��ֵ
	 * 
	 * @param paramName
	 *            Ĭ�ϲ�����
	 * @return ����ֵ
	 */
	public String getDefaultValue(String paramName) {
		return defaultValueMap.get(paramName);
	}

	/**
	 * �������ӵ�where����
	 * 
	 * @param messageId
	 *            ��ϢID
	 * @return where����
	 */
	public String getWhereSql(String messageId) {
		return whereSqlMap.get(messageId);
	}

	/**
	 * �Ƴ�����ӵ�Ĭ��ֵ����
	 * 
	 * @param paramName
	 *            ������
	 * @return ���Ƴ��Ĳ���ֵ
	 */
	public String removeDefaultValue(String paramName) {
		return defaultValueMap.remove(paramName);
	}

	/**
	 * �Ƴ�����ӵ�where����
	 * 
	 * @param messageId
	 *            ��ϢID
	 * @return ���Ƴ���where����
	 */
	public String removeWhereSql(String messageId) {
		return whereSqlMap.remove(messageId);
	}

	/**
	 * �������Ĭ�ϲ���ֵ
	 */
	public void clearDefaultValue() {
		defaultValueMap.clear();
	}

	/**
	 * �������where����
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
			if (msg.getSelectSQL().length() > 0) { // ������selectSql��У��whereSqlMap
				if (whereSqlMap.get(msg.getId()) == null) { // û�д�wheresql
					String mess = "Message(Id:" + msg.getId() + " Description:"
							+ msg.getDescription() + ")������Sql��䵫û�д�Where����";
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
				} else { // ��������
					if (f.getValueSource().equals("Default")
							&& f.getIsRequire().equals("Y")) {
						String defValue = f.getDefaultValue().trim();
						int index = defValue.indexOf("#Constants.");
						if (index > -1) {
							String paramName = defValue.substring("#Constants."
									.length());
							if (defaultValueMap.get(paramName) == null) { // û�д�����
								String mess = "Message(Id:" + msg.getId()
										+ " Description:"
										+ msg.getDescription() + ")�У��ֶ�["
										+ f.getFieldTag() + f.getDescription()
										+ "]���Ĭ��ֵ��䣬��û�б���ֵ";
								throw new DataFormatException(mess);
							}
						}
					}
				}
				if (refMsgName != null) { // ��������message
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
	 * ��Ϊ�ͻ���ʱ�Դ������У��
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
