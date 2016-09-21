/**
 * File Created 2008-1-14 下午02:40:52.
 */
package com.amarsoft.app.edoc;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.xpath.XPath;

/**
 * 电子文档实现类 标签处理类
 * 
 * @author fmwu
 * 
 */
public class ETagHandle {

	// private static String TAG_REGEX = "\\{\\$([^\\{\\}][^\\}]*)\\}";
	// 寻找标签正则表达式
	private static String TAG_REGEX = "\\【\\※([^\\【\\※][^\\※\\】]*)\\※\\】";

	// private static String TAG_REGEX = "【※([^【※][^※】]*)※】";

	/**
	 * 获取Element名称为name的第一个父Element
	 * 
	 * @param element
	 * @param name
	 * @return 满足条件的父Element
	 * @throws JDOMException
	 * @throws IOException
	 */
	private static Element getFirstParent(Element element, String name) throws JDOMException, IOException {
		Element parent = element;
		while (parent != null) {
			if (parent.getQualifiedName().equalsIgnoreCase(name)) {
				return parent;
			}
			parent = parent.getParentElement();
		}
		return parent;
	}

	/**
	 * 获取字符串中的标签名字，标签格式【※TAG※】 如果不存在标签，则返回空值，否则返回标签名字
	 * 
	 * @param str
	 * @return 标签名字
	 */
	private static String getTag(String str) {
		Pattern pattern = Pattern.compile(TAG_REGEX);
		Matcher m = pattern.matcher(str);
		String sTag = null;
		if (m.find()) {
			sTag = m.group(1);
		}
		return sTag;
	}

	/**
	 * 判断字符串中的是否含有标签，标签格式【※TAG※】 如果存在标签，则返true,，否则返回false
	 * 
	 * @param str
	 * @return 标签名字
	 */
	private static boolean isExistTag(String str) {
		Pattern pattern = Pattern.compile(TAG_REGEX);
		Matcher m = pattern.matcher(str);
		return m.find();
	}

	/**
	 * 判断字符串中的是否含有特定标签，标签格式【※TAG※】 如果存在标签，则返true,，否则返回false
	 * 
	 * @param str
	 * @return 标签名字
	 */
	private static boolean isExistTag(String str, String tagName) {
		Pattern pattern = Pattern.compile(TAG_REGEX);
		Matcher m = pattern.matcher(str);
		String sTag = null;
		if (m.find()) {
			sTag = m.group(1);
		}
		if (tagName != null)
			return tagName.equals(sTag);
		else
			return false;
	}

	/**
	 * 检查电子文档格式定义和电子文档数据定义标签情况
	 * 
	 * @throws JDOMException
	 * @throws IOException
	 */
	public static String checkTag(Document doc, Document data) throws JDOMException, IOException {
		// 所有的文本区域，对应存在所有的定义标签
		String xpath_wt = "/w:wordDocument/w:body//w:p/w:r/w:t";
		// 表格中的文本区域，对应存在表格中的标签
		String xpath_tbl_wt = "/w:wordDocument/w:body//w:tbl/w:tr//w:t";
		List list_wt = XPath.selectNodes(doc, xpath_wt);
		List list_tbl_wt = XPath.selectNodes(doc, xpath_tbl_wt);
		// 剔出表格中的文本单元
		list_wt.removeAll(list_tbl_wt);

		boolean passFlag = true;
		StringBuffer sb = new StringBuffer("");
		sb.append("<taglist tabname=\"\" remark=\"单值标签\">\n");

		// 进行标签循环
		for (Iterator i = list_wt.iterator(); i.hasNext();) {
			Element el = (Element) i.next();
			String sTag = getTag(el.getTextTrim());
			if (sTag != null) {
				Element el_data = (Element) XPath.selectSingleNode(data, "/edoc/def/taglist/tag[@name='" + sTag + "']");
				if (el_data == null) {
					passFlag = false;
					sb.append("    ");
					sb.append("<tag name=" + sTag + "> 不存在！！！！>\n");
				}
			}
		}
		if (passFlag) {
			sb.append("    ");
			sb.append("<sucess>单值标签检验通过，文档模板中所有标签都有数据定义！</>\n");
		}
		sb.append("</taglist>\n");

		// 查找所有表格标签
		String xpath_tbl = "/w:wordDocument/w:body//w:tbl";
		List list_tbl = XPath.selectNodes(doc, xpath_tbl);

		int iTable = 0;
		passFlag = true;
		sb.append("<tablelist remark=\"表格标签\">\n");
		// 进行表格循环，看看表格下是否含有标签字段
		for (Iterator i = list_tbl.iterator(); i.hasNext();) {
			Element el_tbl = (Element) i.next();
			iTable++;
			List list2 = XPath.selectNodes(el_tbl, "//w:tbl[" + iTable + "]/w:tr//w:t");
			sb.append("    ");
			sb.append("<table id=\"" + iTable + "\" tabname=\"\"\n");
			for (Iterator i1 = list2.iterator(); i1.hasNext();) {
				Element el = (Element) i1.next();
				String sTag = getTag(el.getTextTrim());
				if (sTag != null) {
					Element el_data = (Element) XPath.selectSingleNode(data, "/edoc/def/tablelist/table/tag[@name='" + sTag + "']");
					if (el_data == null) {
						sb.append("    ");
						sb.append("<tag name=" + sTag + "> 不存在！！！！</>\n");
					}
				}
			}
			if (passFlag) {
				sb.append("    ");
				sb.append("    ");
				sb.append("<sucess>表格中标签检验通过，文档模板中所有表格标签都有数据定义！</>\n");
			}
			sb.append("    ");
			sb.append("</table>\n");
		}
		sb.append("</tablelist>\n");
		return sb.toString();
	}

	/**
	 * 获取电子文档格式定义的标签列表
	 * 
	 * @throws JDOMException
	 * @throws IOException
	 */
	public static String getTagList(Document doc) throws JDOMException, IOException {
		// 所有的文本区域，对应存在所有的定义标签
		String xpath_wt = "/w:wordDocument/w:body//w:p/w:r/w:t";
		// 表格中的文本区域，对应存在表格中的标签
		String xpath_tbl_wt = "/w:wordDocument/w:body//w:tbl/w:tr//w:t";
		List list_wt = XPath.selectNodes(doc, xpath_wt);
		List list_tbl_wt = XPath.selectNodes(doc, xpath_tbl_wt);
		// 剔出表格中的文本单元
		//list_wt.removeAll(list_tbl_wt);

		StringBuffer sb = new StringBuffer("");
		int iCount = 0;
		sb.append("<taglist remark=\"单值标签列表\" table=\"\" where=\"\">\n");

		// 进行标签循环
		for (Iterator i = list_wt.iterator(); i.hasNext();) {
			Element el = (Element) i.next();
			String sTag = getTag(el.getTextTrim());
			if (sTag != null) {
				iCount++;
				sb.append("    ");
				sb.append("<tag");
				sb.append(" id=\"" + iCount + "\"");
				sb.append(" name=\"" + sTag + "\"");
				sb.append(" type=\"S\"");
				sb.append(" datasrc=\"\"");
				sb.append(" column=\"\"");
				sb.append(">");
				sb.append("</tag>\n");
			}
		}
		sb.append("</taglist>\n");

		// 查找所有表格标签
		String xpath_tbl = "/w:wordDocument/w:body//w:tbl";
		List list_tbl = XPath.selectNodes(doc, xpath_tbl);

		int iTable = 0;
		sb.append("<tablelist remark=\"表格标签\">\n");
		// 进行表格循环，看看表格下是否含有标签字段
		for (Iterator i = list_tbl.iterator(); i.hasNext();) {
			Element el_tbl = (Element) i.next();
			iTable++;
			iCount = 0;
			List list2 = XPath.selectNodes(el_tbl, "//w:tbl[" + iTable + "]/w:tr//w:t");
			sb.append("    ");
			sb.append("<table id=\"" + iTable + "\" name=\"表格名称\" tabname=\"\" cols=\"\" where=\"\">\n");
			for (Iterator i1 = list2.iterator(); i1.hasNext();) {
				Element el = (Element) i1.next();
				String sTag = getTag(el.getTextTrim());
				if (sTag != null) {
					iCount++;
					sb.append("    ");
					sb.append("    ");
					sb.append("<tag");
					sb.append(" id=\"" + (iTable * 100 + iCount) + "\"");
					sb.append(" name=\"" + sTag + "\"");
					sb.append(" type=\"S\"");
					sb.append(" datasrc=\"col\"");
					sb.append(" column=\"\"");
					sb.append(">");
					sb.append("</tag>\n");
				}
			}
			sb.append("    ");
			sb.append("</table>\n");
		}
		sb.append("</tablelist>\n");
		return sb.toString();
	}

	/**
	 * 获取电子文档数据定义的标签列表
	 * 
	 * @param def
	 *            电子文档数据定义
	 * @throws JDOMException
	 * @throws IOException
	 */
	public static String getDefTagList(Document def) throws JDOMException, IOException {
		StringBuffer sb = new StringBuffer("");
		// 普通标签定义
		String xpath = "/edoc/def/taglist/tag";
		// 表格标签定义
		String xpath_tbl = "/edoc/def/tablelist/table";
		List list = XPath.selectNodes(def, xpath);
		List list_tbl = XPath.selectNodes(def, xpath_tbl);

		sb.append("<taglist table=\"\">\n");
		for (Iterator i = list.iterator(); i.hasNext();) {
			Element el_tag = (Element) i.next();
			sb.append("    ");
			sb.append("<tag");
			sb.append(" name=\"" + el_tag.getAttributeValue("name") + "\"");
			sb.append(" type=\"" + el_tag.getAttributeValue("type") + "\"");
			sb.append(" col=\"" + el_tag.getAttributeValue("col") + "\"");
			sb.append(">");
			sb.append(el_tag.getValue());
			sb.append("</tag>\n");
		}
		sb.append("<taglist>\n");

		sb.append("<tablelist>\n");
		for (Iterator i = list_tbl.iterator(); i.hasNext();) {
			Element el_table = (Element) i.next();
			sb.append("    ");
			sb.append("<table");
			sb.append(" name=\"" + el_table.getAttributeValue("name") + "\"");
			sb.append(">");
			sb.append("\n");

			List list_table_tag = el_table.getChildren();
			for (Iterator i_tag = list_table_tag.iterator(); i_tag.hasNext();) {
				Element el_tag = (Element) i_tag.next();
				sb.append("    ");
				sb.append("    ");
				sb.append("<tag");
				sb.append(" name=\"" + el_tag.getAttributeValue("name") + "\"");
				sb.append(" type=\"" + el_tag.getAttributeValue("type") + "\"");
				sb.append(">");
				sb.append("</tag>\n");
			}
			sb.append("    ");
			sb.append("</table>\n");
		}
		sb.append("</tablelist>\n");
		return sb.toString();
	}

	/**
	 * 用data数据对象替换文档对象中的单值标签(包括带换行的数据)
	 * 
	 * @param doc
	 *            文档对象
	 * @param data
	 *            数据对象
	 * @throws JDOMException
	 * @throws IOException
	 */
	static void replaceSimpleTag(Document doc, Document data) throws JDOMException, IOException {
		// 单值w:t文本标签
		//String xpath_doc_wt = "/w:wordDocument/w:body//w:p/w:r/w:t";
		String xpath_doc_wt = "/w:wordDocument/w:body//w:p/w:r/w:t";
		
		// 表格内w:t文本标签
		String xpath_doc_tbl_wt = "/w:wordDocument/w:body//w:tbl/w:tr//w:t";
		//String xpath_doc_tbl_wt = "/w:wordDocument/w:body//w:tbl/w:tr/w:tc/w:p/w:r/w:t";

		List list_doc = XPath.selectNodes(doc, xpath_doc_wt);
		List list_doc_temp = XPath.selectNodes(doc, xpath_doc_wt);

		// 剔除表格中的w:t文本对象
		//list_doc.removeAll(XPath.selectNodes(doc, xpath_doc_tbl_wt));
		//list_doc_temp.removeAll(XPath.selectNodes(doc, xpath_doc_tbl_wt));

		// 剔除不存在标签的w:t文本对象
		for (Iterator i = list_doc_temp.iterator(); i.hasNext();) {
			Element el_wt = (Element) i.next();
			if (!isExistTag(el_wt.getTextTrim())) {
				list_doc.remove(el_wt);
			}
		}

		// 单值数据
		String xpath_data = "/edoc/data/taglist/tag";
		// 逐个单值数据循环处理
		List list_data = XPath.selectNodes(data, xpath_data);
		replaceGroupTag(list_doc, list_data, data);
	}

	/**
	 * 根据一组数据替换一组标签
	 * 
	 * @param list_doc
	 *            被替换的标签
	 * @param list_data
	 *            被替换的数据
	 * @param data
	 *            文档数据，包含代码表数据
	 * @throws JDOMException
	 * @throws IOException
	 */
	static void replaceGroupTag(List list_doc, List list_data, Document data) throws JDOMException, IOException {
		// 对数据进行循环处理
		for (Iterator i = list_data.iterator(); i.hasNext();) {
			Element el_data = (Element) i.next();
			String tagName = el_data.getAttributeValue("name");
			String value = el_data.getText();
			String isExistwp = el_data.getAttributeValue("existwp");

			// 根据数据进行逐个标签文本处理
			for (Iterator i1 = list_doc.iterator(); i1.hasNext();) {
				Element el_wt = (Element) i1.next();
				String text = el_wt.getTextTrim();
				// 假如是该标签，则进行处理
				if (isExistTag(text, tagName)) {
					// 假如数据是多行
					if ("true".equals(isExistwp)) {
						// 得到行对象
						Element el_wp = getFirstParent(el_wt, "w:p");
						// 获取当前对象的父对象
						Element parent = el_wp.getParentElement();
						int iPos = parent.indexOf(el_wp);
						// 拷贝将原始的行标签对象
						Element el_wp_copy = (Element) el_wp.clone();
						el_wp.detach();
						List list_wp = el_data.getChildren("wp");
						for (Iterator i2 = list_wp.iterator(); i2.hasNext();) {
							// 复制行对象
							el_wp = (Element) el_wp_copy.clone();
							// 插入对象
							parent.addContent(iPos++, el_wp);

							// 处理行对象
							Element el_wp_data = (Element) i2.next();
							String wp_value = el_wp_data.getText();
							replaceElementWp(el_wp, tagName, wp_value);
						}
					} else {
						el_wt.setText(relpaceTag(text, tagName, value));
					}
				}
			}
		}
	}

	/**
	 * 根据TagNme对数据对象替换文档行(w:p)对象中的文本(w:t)标签进行值替换
	 * 
	 * @param el_wp
	 *            文档行对象
	 * @param tagName
	 *            标签名字
	 * @param value
	 *            替换值
	 * @throws JDOMException
	 * @throws IOException
	 */
	static void replaceElementWp(Element el_wp, String tagName, String value) throws JDOMException, IOException {
		List list_wt = XPath.selectNodes(el_wp, "//w:p/w:r/w:t");
		for (Iterator i = list_wt.iterator(); i.hasNext();) {
			Element el_wt = (Element) i.next();
			String text = el_wt.getTextTrim();
			if (isExistTag(text, tagName)) {
				el_wt.setText(relpaceTag(text, tagName, value));
			}
		}
	}

	/**
	 * 用data数据对象替换文档对象中的表格标签(多值)
	 * 
	 * @param doc
	 *            文档对象
	 * @param data
	 *            数据对象
	 * @throws JDOMException
	 * @throws IOException
	 */
	static void replaceTableTag(Document doc, Document data) throws JDOMException, IOException {
		String xpath_doc = "/w:wordDocument/w:body//w:tbl//w:tr//w:t";

		List list_doc = XPath.selectNodes(doc, xpath_doc);
		List list_doc_temp = XPath.selectNodes(doc, xpath_doc);

		// 剔除不存在标签的w:t文本对象
		for (Iterator i = list_doc_temp.iterator(); i.hasNext();) {
			Element el_wt = (Element) i.next();
			if (!isExistTag(el_wt.getTextTrim())) {
				list_doc.remove(el_wt);
			}
		}

		String xpath_data = "/edoc/data/tablelist/table";
		List list_data_tbl = XPath.selectNodes(data, xpath_data);

		// 表格循环[数据]
		for (Iterator i = list_data_tbl.iterator(); i.hasNext();) {
			Element el_tbl_data = (Element) i.next();
			// 得到表格行数据
			List list_datalist = el_tbl_data.getChildren("datalist");
			// 获取表格名字
			String tblName = el_tbl_data.getAttributeValue("name");
			// 得到表格行中的第一个Tag[数据]
			String xpath = "/edoc/data/tablelist/table[@name='" + tblName + "']/datalist/tag";
			Element el_data_tag = (Element) XPath.selectSingleNode(data, xpath);
			String tagName = el_data_tag.getAttributeValue("name");

			// 根据Tag名字获取文档的Tag标签
			Element el_doc_tag = null;
			for (Iterator i1 = list_doc.iterator(); i1.hasNext();) {
				Element el_wt = (Element) i1.next();
				// 根据Tag名字查找文档的Tag标签
				if (isExistTag(el_wt.getTextTrim(), tagName)) {
					el_doc_tag = el_wt;
					break;
				}
			}

			// 文档行对象
			Element el_doc_tr = null;
			// 假如在文档中找不到相应的标签，则进行下一个表格替换
			if (el_doc_tag == null)
				continue;
			else {
				// 得到文档的行对象
				el_doc_tr = getFirstParent(el_doc_tag, "w:tr");
			}

			// 获取文档行对象的父对象
			Element el_doc_tr_parent = el_doc_tr.getParentElement();
			int iPos = el_doc_tr_parent.indexOf(el_doc_tr);
			// 拷贝将原始的行标签对象
			Element el_doc_tr_copy = (Element) el_doc_tr.clone();
			el_doc_tr.detach();

			// 数据表格行循环
			for (Iterator i1 = list_datalist.iterator(); i1.hasNext();) {
				// 复制表行对象
				el_doc_tr = (Element) el_doc_tr_copy.clone();
				// 插入表格行对象
				el_doc_tr_parent.addContent(iPos++, el_doc_tr);

				// 获取表格行数据
				Element el_data_tr = (Element) i1.next();
				List list_data_tr = el_data_tr.getChildren("tag");
				List list_doc_tr = XPath.selectNodes(el_doc_tr, "//w:tr//w:t");
				replaceGroupTag(list_doc_tr, list_data_tr, data);
			}
		}
	}

	/**
	 * 将字符串中和标签名字对应的标签替换为相应值
	 * 
	 * @param src
	 *            原始串
	 * @param tagName
	 *            标签名字
	 * @param value
	 *            标签替换值
	 * @return 替换后的字符串
	 */
	private static String relpaceTag(String src, String tagName, String value) {
		StringBuffer sb = new StringBuffer();
		Pattern pattern = Pattern.compile(TAG_REGEX);
		Matcher m = pattern.matcher(src);
		while (m.find()) {
			String v = m.group(1);
			if (value != null && tagName.equals(v)) {
				m.appendReplacement(sb, value);
			}
		}
		m.appendTail(sb);
		return sb.toString();
	}
}
