/**
 * File Created 2008-1-14 下午02:40:52.
 */
package com.amarsoft.app.edoc;

import java.text.DecimalFormat;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.xpath.XPath;

import com.amarsoft.amarscript.ASMethod;
import com.amarsoft.amarscript.Any;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;

/**
 * 电子文档实现类 标签处理类
 * 
 * @author fmwu
 * 
 */
public class EDataHandle {
	/**
	 * 得到数据Document
	 * 
	 * @return
	 * @throws Exception
	 */
	public static Document getData(Document def, Map map, Transaction Sqlca) throws Exception {
		// 初始化参数值
		String xpath_parm = "/edoc/def/parmlist/parm";
		List list_parm = XPath.selectNodes(def, xpath_parm);
		for (Iterator i = list_parm.iterator(); i.hasNext();) {
			Element el_tag = (Element) i.next();
			String parmName = el_tag.getAttributeValue("name");
			String sDataSrc = el_tag.getAttributeValue("datasrc");
			// 根据输入值进行取值
			if ("input".equals(sDataSrc)) {
				String sValue = (String) map.get(parmName);
				el_tag.setText(sValue);
			}
		}

		for (Iterator i = list_parm.iterator(); i.hasNext();) {
			Element el_tag = (Element) i.next();
			String sDataSrc = el_tag.getAttributeValue("datasrc");
			String sType = el_tag.getAttributeValue("type");
			String sValue = el_tag.getTextTrim();

			// 根据sql进行取值
			if ("sql".equals(sDataSrc)) {
				// sql取值
				String sSql = el_tag.getAttributeValue("sql");
				sSql = replaceStr(sSql, list_parm);
				// 实际的sql值
				el_tag.setAttribute("sql", sSql);
				sValue = getSqlValue(sSql, Sqlca);
			} else if ("method".equals(sDataSrc)) {
				// 方法取值
				String sClass = el_tag.getAttributeValue("class");
				String sMethod = el_tag.getAttributeValue("method");
				String sArgs = el_tag.getAttributeValue("args");
				sArgs = replaceStr(sArgs, list_parm);
				// 实际的args值
				el_tag.setAttribute("args", sArgs);
				ASMethod method = new ASMethod(sClass, sMethod, Sqlca);
				Any anyValue = method.execute(sArgs);
				sValue = anyValue.toStringValue();
			}

			// 假如数据不为空
			if (!"".equals(sValue)) {
				// 根据数据进行值转换
				if ("E".equals(sType)) {
					// 小写金额
					String fmt = "##,##0.00";
					DecimalFormat numberFormat = new DecimalFormat(fmt);
					sValue = numberFormat.format(Double.parseDouble(sValue));
				} else if ("M".equals(sType)) {
					// 大写金额
					sValue = StringFunction.numberToChinese(Double.parseDouble(sValue));
				}
			}
			el_tag.setText(sValue);
		}

		Element el_data = (Element) XPath.selectSingleNode(def, "/edoc/data");
		Element el_parent = el_data.getParentElement();
		el_data.detach();
		el_data = new Element("data");

		// 普通标签定义
		String xpath = "/edoc/def/taglist/tag";
		List list = XPath.selectNodes(def, xpath);

		// 取得表名
		Element el_def = (Element) XPath.selectSingleNode(def, "/edoc/def/taglist");
		String sDefaultTable = el_def.getAttributeValue("table");
		String sDefaultWhere = el_def.getAttributeValue("where");
		sDefaultWhere = replaceStr(sDefaultWhere, list_parm);

		Element el_taglist = new Element("taglist");
		el_taglist.setAttribute("remark", "数据列表");
		el_data.addContent(el_taglist);
		// 单值数据处理
		for (Iterator i = list.iterator(); i.hasNext();) {
			Element el_tag_def = (Element) i.next();
			// 复制元素
			Element el_tag = (Element) el_tag_def.clone();
			el_taglist.addContent(el_tag);
			String sType = el_tag.getAttributeValue("type");
			String sDataSrc = el_tag.getAttributeValue("datasrc");
			String sValue = "";

			// 根据数据源进行取值
			if ("col".equals(sDataSrc)) {
				// 字段取值
				String sColumn = el_tag.getAttributeValue("column");
				//实际的column值
				sColumn = replaceStr(sColumn, list_parm);
				String sTable = el_tag.getAttributeValue("table");
				if (sTable == null || "".equals(sTable))
					sTable = sDefaultTable;
				// 实际的table值
				el_tag.setAttribute("table", sTable);
				String sWhere = el_tag.getAttributeValue("where");
				if (sWhere == null || "".equals(sWhere))
					sWhere = sDefaultWhere;
				else
					sWhere = replaceStr(sWhere, list_parm);
				// 实际的where值
				el_tag.setAttribute("where", sWhere);
				sValue = getColValue(sColumn, sTable, sWhere, Sqlca);
			} else if ("sql".equals(sDataSrc)) {
				// sql取值
				String sSql = el_tag.getAttributeValue("sql");
				sSql = replaceStr(sSql, list_parm);
				// 实际的sql值
				el_tag.setAttribute("sql", sSql);
				sValue = getSqlValue(sSql, Sqlca);
			} else if ("method".equals(sDataSrc)) {
				// 方法取值
				String sClass = el_tag.getAttributeValue("class");
				String sMethod = el_tag.getAttributeValue("method");
				String sArgs = el_tag.getAttributeValue("args");
				sArgs = replaceStr(sArgs, list_parm);
				// 实际的args值
				el_tag.setAttribute("args", sArgs);
				ASMethod method = new ASMethod(sClass, sMethod, Sqlca);
				Any anyValue = method.execute(sArgs);
				sValue = anyValue.toStringValue();
			}

			// 假如数据不为空
			if (!"".equals(sValue)) {
				// 根据数据进行值转换
				if ("E".equals(sType)) {
					// 小写金额
					String fmt = "##,##0.00";
					DecimalFormat numberFormat = new DecimalFormat(fmt);
					sValue = numberFormat.format(Double.parseDouble(sValue));
				} else if ("M".equals(sType)) {
					// 大写金额
					sValue = StringFunction.numberToChinese(Double.parseDouble(sValue));
				}
			}
			else {
				String sShowNull = el_tag.getAttributeValue("shownull");
				if ("false".equals(sShowNull)) {
					el_tag.setText("");
				}
			}

			// 设置实际值
			String sText = el_tag.getTextTrim();
			if ("fix".equals(sDataSrc)) {
				sValue = sText;
			} else {
				// 假如不是固定取值，处理值
				if (!"".equals(sText)) {
					//替换自变量
					sValue = StringFunction.replace(sText, "#value#", sValue);
				}
			}

			if (!"".equals(sText)) {
				//替换参数
				sValue = replaceStr(sValue, list_parm);
			}

			// 假如数据是代码，根据代码进行取值
			if ("C".equals(sType)) {
				String sId = el_tag.getAttributeValue("id");
				String sName = el_tag.getAttributeValue("name");
				Element tag = getItemTag(sName, sValue, def);
				if (tag != null) {
					el_tag.detach();
					el_tag = (Element) tag.clone();
					el_taglist.addContent(el_tag);
					el_tag.setAttribute("id", sId);
					el_tag.setAttribute("name", sName);
					el_tag.setAttribute("type", sType);
					el_tag.setAttribute("datasrc", sDataSrc);

					//代码中支持参数
					sText=el_tag.getTextTrim();
					sText = replaceStr(sText, list_parm);
					el_tag.setText(sText);

					List list_tag_wp = tag.getChildren("wp");
					// 代码内的每行数据处理
					for (Iterator i_tag_wp = list_tag_wp.iterator(); i_tag_wp.hasNext();) {
						Element tag_wp= (Element) i_tag_wp.next();
						Element el_tag_wp = (Element) tag_wp.clone();
						el_tag.addContent(el_tag_wp);
						sText=el_tag_wp.getTextTrim();
						sText = replaceStr(sText, list_parm);
						el_tag_wp.setText(sText);
					}
				}
			}
			else {
				//代码中支持参数
				String sLength = el_tag.getAttributeValue("length");
				if (sLength != null && !"".equals(sLength)) {
					int iLen = Integer.parseInt(sLength);
					sValue = specifyLengthRightFill(sValue,iLen,"-");
				}
				el_tag.setText(sValue);
				
			}

			// 判断数据是否存在回车
			if (sValue.indexOf("\n") != -1) {
				el_tag.setAttribute("existwp", "true");
				el_tag.setText("");
				String[] aStr = sValue.split("\n");
				for (int i1 = 0; i1 < aStr.length; i1++) {
					Element el_tag_wp = new Element("wp");
					el_tag_wp.setText(aStr[i1]);
					el_tag.addContent(el_tag_wp);
				}
			}
		}

		// 表格标签定义
		String xpath_tbl = "/edoc/def/tablelist/table";
		List list_tbl = XPath.selectNodes(def, xpath_tbl);
		// 表格处理
		Element el_tablelist = new Element("tablelist");
		el_tablelist.setAttribute("remark", "表格列表");
		el_data.addContent(el_tablelist);

		// 表格循环
		for (Iterator i = list_tbl.iterator(); i.hasNext();) {
			Element el_table = (Element) i.next();
			Element el_table_data = new Element("table");
			el_table_data.setAttribute("name", el_table.getAttributeValue("name"));

			el_tablelist.addContent(el_table_data);

			// 获取表名
			String sTable = el_table.getAttributeValue("table");
			sTable = replaceStr(sTable, list_parm);
			el_table_data.setAttribute("table", sTable);

			// 替换Where条件参数
			String sWhere = el_table.getAttributeValue("where");
			sWhere = replaceStr(sWhere, list_parm);
			el_table_data.setAttribute("where", sWhere);

			// 获取字段集合
			String sCols = el_table.getAttributeValue("cols");
			el_table_data.setAttribute("cols", sCols);

			String sSql = "select " + sCols + " from " + sTable + " where " + sWhere;
			// 获取结果集
			ASResultSet rs = Sqlca.getASResultSet(sSql);
			boolean isExsitData = false;
			while (rs.next()) {
				isExsitData = true;
				List list_table_tag = el_table.getChildren();
				Element el_table_datalist = new Element("datalist");
				el_table_data.addContent(el_table_datalist);

				// 每行数据处理
				for (Iterator i_tag = list_table_tag.iterator(); i_tag.hasNext();) {
					Element el_tag_src = (Element) i_tag.next();
					// 复制元素
					Element el_tag = (Element) el_tag_src.clone();
					el_table_datalist.addContent(el_tag);

					String sType = el_tag.getAttributeValue("type");
					String sDataSrc = el_tag.getAttributeValue("datasrc");
					String sValue = "";

					// 根据数据源进行取值
					if ("col".equals(sDataSrc)) {
						// 字段取值
						String sColumn = el_tag.getAttributeValue("column");
						//实际的column值
						sColumn = replaceStr(sColumn, list_parm);
						sValue = rs.getString(sColumn);
						if (sValue==null)
							sValue = "";
					}

					// 假如数据不为空
					if (!"".equals(sValue)) {
						// 根据数据进行值转换
						if ("E".equals(sType)) {
							// 小写金额
							String fmt = "##,##0.00";
							DecimalFormat numberFormat = new DecimalFormat(fmt);
							sValue = numberFormat.format(Double.parseDouble(sValue));
						} else if ("M".equals(sType)) {
							// 大写金额
							sValue = StringFunction.numberToChinese(Double.parseDouble(sValue));
						}
					}

					// 设置实际值
					String sText = el_tag.getTextTrim();
					if ("fix".equals(sDataSrc)) {
						sValue = sText;
					} else {
						// 假如不是固定取值，处理值
						if (!"".equals(sText)) {
							sValue = StringFunction.replace(sText, "#value#", sValue);
						}
					}

					// 假如数据是代码，根据代码进行取值
					if ("C".equals(sType)) {
						String sId = el_tag.getAttributeValue("id");
						String sName = el_tag.getAttributeValue("name");
						Element tag = getItemTag(sName, sValue, def);
						if (tag != null) {
							el_tag.detach();
							el_tag = (Element) tag.clone();
							el_table_datalist.addContent(el_tag);
							el_tag.setAttribute("id", sId);
							el_tag.setAttribute("name", sName);
							el_tag.setAttribute("type", sType);
							el_tag.setAttribute("datasrc", sDataSrc);

							// 代码中支持参数
							sText=el_tag.getTextTrim();
							sText = replaceStr(sText, list_parm);
							el_tag.setText(sText);

							List list_tag_wp = tag.getChildren("wp");
							// 代码内的每行数据处理
							for (Iterator i_tag_wp = list_tag_wp.iterator(); i_tag_wp.hasNext();) {
								Element tag_wp= (Element) i_tag_wp.next();
								Element el_tag_wp = (Element) tag_wp.clone();
								el_tag.addContent(el_tag_wp);
								sText=el_tag_wp.getTextTrim();
								sText = replaceStr(sText, list_parm);
								el_tag_wp.setText(sText);
							}
						}
					}
					else {
						el_tag.setText(sValue);
					}

					// 判断数据是否存在回车
					if (sValue.indexOf("\n") != -1) {
						el_tag.setAttribute("existwp", "true");
						el_tag.setText("");
						String[] aStr = sValue.split("\n");
						for (int i1 = 0; i1 < aStr.length; i1++) {
							Element el_tag_wp = new Element("wp");
							el_tag_wp.setText(aStr[i1]);
							el_tag.addContent(el_tag_wp);
						}
					}
				}
			}
			rs.close();
			if (!isExsitData) {
				List list_table_tag = el_table.getChildren();
				Element el_table_datalist = new Element("datalist");
				el_table_data.addContent(el_table_datalist);

				// 每行数据处理
				for (Iterator i_tag = list_table_tag.iterator(); i_tag.hasNext();) {
					Element el_tag = (Element) i_tag.next();
					Element el_tag_data = (Element) el_tag.clone();
					el_tag_data.setText(" ");
					el_table_datalist.addContent(el_tag_data);
				}
			}
		}
		el_parent.addContent(el_data);
		return def;
	}

	/**
	 * 根据代码的itemno获取itemname,数据来源于Document
	 * 
	 * @param codono
	 *            代码名称，一般指标签名称
	 * @param itemno
	 *            代码编号
	 * @param data
	 *            代码数据来源文档
	 * @return 项目名称
	 * 
	 * @throws JDOMException
	 */
	private static Element getItemTag(String codono, String itemno, Document data) throws JDOMException {
		String xpath = "/edoc/code/codelist/code[@codeno='" + codono + "']/codeitem[@itemno='" + itemno + "']/tag";
		Element e = (Element) XPath.selectSingleNode(data, xpath);
		return e;
	}

	/**
	 * 根据key获取合同某个字段的值
	 */
	private static String getColValue(String sCol, String sTable, String sWhere, Transaction Sqlca) throws Exception {
		String sSql = "Select " + sCol + " from " + sTable + " where " + sWhere + "";
		return getSqlValue(sSql, Sqlca);
	}

	/**
	 * 获取SQL中的单值
	 * @param sSql 
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	private static String getSqlValue(String sSql, Transaction Sqlca) throws Exception {
		String value = Sqlca.getString(sSql);
		if (value == null)
			value = "";
		return value;
	}

	/**
	 * 右补位 字符sdata右补字符sFillchar，使sdata的长度达到len个
	 */
	private static String specifyLengthRightFill(String sdata, int len, String sFillchar) {
		int j = len - sdata.getBytes().length;
		for (int k = 1; k <= j; k++)
			sdata = sdata + sFillchar;

		if (j < 0)
			sdata = new String(sdata.getBytes(), 0, len);
		return sdata;
	}

	/**
	 * 替换参数值
	 */
	private static String replaceStr(String sStr, List list) throws Exception {
		for (Iterator i_tag = list.iterator(); i_tag.hasNext();) {
			Element el_tag = (Element) i_tag.next();
			sStr = StringFunction.replace(sStr, "#" + el_tag.getAttributeValue("name"), el_tag.getTextTrim());
		}
		return sStr;
	}
}
