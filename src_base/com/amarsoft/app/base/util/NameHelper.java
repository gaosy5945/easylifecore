package com.amarsoft.app.base.util;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.cache.NameCache;

/**
 * @author t-wangyg
 *
 */
public class NameHelper {
	/**
	 * ��ȡ����������ĳ������ֵ
	 * 
	 * @param codeNo
	 * @param itemNoString
	 * @param nameColumnID
	 * @param splitCharacter
	 * @return
	 * @throws Exception
	 */
	public static String getMultiCodeItemAttribute(String codeNo,
			String itemNoString, String nameColumnID, String splitCharacter)
			throws Exception {
		if (itemNoString == null || "".equals(itemNoString))
			return "";
		if (splitCharacter == null || splitCharacter.length() == 0)
			splitCharacter = ",";
		String[] keyValueArray = itemNoString.split(splitCharacter);

		String nameValue = "";
		for (String itemNo : keyValueArray)
			nameValue += splitCharacter
					+ CodeCache.getItem(codeNo, itemNo).getItemName();

		if (nameValue.length() > 0)
			nameValue = nameValue.substring(1);
		return nameValue;
	}

	/**
	 * ��ȡ����������ĳ������ֵ���Զ��ŷָ�
	 * 
	 * @param codeNo
	 * @param itemNoString
	 * @param nameColumnID
	 * @return
	 * @throws Exception
	 */
	public static String getMultiCodeItemAttribute(String codeNo,
			String itemNoString, String nameColumnID) throws Exception {
		return getMultiCodeItemAttribute(codeNo, itemNoString, nameColumnID,
				",");
	}

	/**
	 * ��ö�������������
	 * 
	 * @param codeNo
	 * @param itemNoString
	 * @param splitCharacter
	 * @return
	 * @throws Exception
	 */
	public static String getMultiCodeItemName(String codeNo,
			String itemNoString, String splitCharacter) throws Exception {
		if (itemNoString == null || "".equals(itemNoString))
			return "";
		if (splitCharacter == null || splitCharacter.length() == 0)
			splitCharacter = ",";
		String[] keyValueArray = itemNoString.split(splitCharacter);

		String nameValue = "";
		for (String itemNo : keyValueArray)
			if (CodeCache.getItem(codeNo, itemNo) != null)
				nameValue += splitCharacter
						+ CodeCache.getItem(codeNo, itemNo).getItemName();

		if (nameValue.length() > 0)
			nameValue = nameValue.substring(1);
		return nameValue;
	}

	/**
	 * ��ö������������ƣ��Զ��ŷָ�
	 * 
	 * @param codeNo
	 * @param itemNoString
	 * @return
	 * @throws Exception
	 */
	public static String getMultiCodeItemName(String codeNo, String itemNoString)
			throws Exception {
		return getMultiCodeItemName(codeNo, itemNoString, ",");
	}

	/**
	 * ���ݱ��������ȡ������¼��ĳ���ֶ�ֵ
	 * 
	 * @param tableName
	 * @param nameColumnID
	 * @param keyColumnID
	 * @param keyValue
	 *            ���Էָ����ֿ�
	 * @param splitCharacter
	 * @return �Էָ����ֿ������ض�����¼���ֶ�ֵ���Էָ�������
	 * @throws Exception
	 */
	public static String getMultiObjectName(String tableName,
			String nameColumnID, String keyColumnID, String keyValue,
			String splitCharacter) throws Exception {
		if (keyValue == null || "".equals(keyValue))
			return "";
		if (splitCharacter == null || splitCharacter.length() == 0)
			splitCharacter = ",";
		String[] keyValueArray = keyValue.split(splitCharacter);

		String nameValue = "";
		for (String value : keyValueArray)
			nameValue += splitCharacter
					+ NameCache.getName(tableName, nameColumnID, keyColumnID,
							value);

		if (nameValue.length() > 0)
			nameValue = nameValue.substring(1);
		return nameValue;
	}

	/**
	 * ���ݱ��������ȡ������¼��ĳ���ֶ�ֵ
	 * 
	 * @param tableName
	 * @param nameColumnID
	 * @param keyColumnID
	 * @param keyValue
	 *            ���Էָ����ֿ�
	 * @return �Էָ����ֿ������ض�����¼���ֶ�ֵ���Էָ�������
	 * @throws Exception
	 */
	public static String getMultiObjectName(String tableName,
			String nameColumnID, String keyColumnID, String keyValue)
			throws Exception {
		return NameHelper.getMultiObjectName(tableName, nameColumnID,
				keyColumnID, keyValue, ",");
	}

	/**
	 * ���ݱ��������ȡ������¼��ĳ���ֶ�ֵ
	 * 
	 * @param tableName
	 * @param nameColumnID
	 * @param filterString
	 * @return �Էָ����ֿ������ض�����¼���ֶ�ֵ���Էָ�������
	 * @throws Exception
	 */
	public static String getJBOAttributeName(String jboClassName,
			String nameColumnID, String filterString) throws Exception {
		String jboQueryString = "";
		BusinessObject[] parameters = JBOHelper.parseJBOParamter(filterString,
				";", ",");
		BusinessObjectManager bomanager = BusinessObjectManager
				.createBusinessObjectManager();
		List<BusinessObject> l = new ArrayList<BusinessObject>();
		for (BusinessObject parameter : parameters) {
			if (!StringX.isEmpty(jboQueryString))
				jboQueryString += " and ";
			String parameterName = parameter.getString("Name");
			if (StringX.isEmpty(parameterName))
				continue;
			String operator = parameter.getString("Operate");
			if (StringX.isEmpty(operator))
				operator = "=";
			operator = operator.trim();

			if ("in".equalsIgnoreCase(operator)) {
				jboQueryString += parameterName + " " + operator + " (:"
						+ parameterName + ")";
				String[] sFilter = filterString.split("in");
				if (sFilter[1].equals(" "))
					l = bomanager.loadBusinessObjects(jboClassName,
							jboQueryString, sFilter[0], "");
				else if (sFilter[1].contains(",")) {
					String[] str = sFilter[1].split(",");
					String sk = "";
					for (String s : str) {
						s = s.replaceAll(" ", "");
						sk += "," + s;
					}
					String a0 = sFilter[0];
					l = bomanager.loadBusinessObjects(jboClassName,
							jboQueryString, sFilter[0].replaceAll(" ", ""),
							sk.split(","));
				} else
					l = bomanager.loadBusinessObjects(jboClassName,
							jboQueryString, sFilter[0],
							sFilter[1].replaceAll(" ", ""));
			} else {
				jboQueryString += parameterName + " " + operator + " :"
						+ parameterName + "";
				filterString = filterString.replaceAll(";", "=");
				String[] sFilter = filterString.split("=");
				if (sFilter.length == 3)
					l = bomanager.loadBusinessObjects(jboClassName,
							jboQueryString, sFilter[0], sFilter[1], sFilter[2],
							"");
				else
					l = bomanager.loadBusinessObjects(jboClassName,
							jboQueryString, sFilter[0], sFilter[1], sFilter[2],
							sFilter[3]);
			}
		}
		if (l == null || l.isEmpty())
			return "";
		String result = "";
		for (BusinessObject o : l)
			result += "," + o.getAttribute(nameColumnID);
		return result.replaceFirst(",", "");
	}
}
