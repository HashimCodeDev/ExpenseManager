<%-- Modern form components with validation and better UX --%>

<%-- Input Field Component --%>
<%!
public String renderInput(String id, String name, String type, String label, String placeholder, String value, boolean required, String icon) {
    return String.format(
        "<div class=\"space-y-2\">" +
        "  <label for=\"%s\" class=\"block text-sm font-medium text-gray-700\">%s%s</label>" +
        "  <div class=\"relative\">" +
        "    %s" +
        "    <input type=\"%s\" id=\"%s\" name=\"%s\" value=\"%s\" placeholder=\"%s\" %s" +
        "           class=\"w-full pl-%s pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200 bg-white\">" +
        "  </div>" +
        "</div>",
        id, label, required ? " <span class=\"text-red-500\">*</span>" : "",
        icon != null ? String.format("<div class=\"absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none\">%s</div>", icon) : "",
        type, id, name, value != null ? value : "", placeholder,
        required ? "required" : "",
        icon != null ? "10" : "4"
    );
}

public String renderSelect(String id, String name, String label, String[] options, String[] values, String selectedValue, boolean required, String icon) {
    StringBuilder optionsHtml = new StringBuilder();
    for (int i = 0; i < options.length; i++) {
        String selected = values[i].equals(selectedValue) ? "selected" : "";
        optionsHtml.append(String.format("<option value=\"%s\" %s>%s</option>", values[i], selected, options[i]));
    }
    
    return String.format(
        "<div class=\"space-y-2\">" +
        "  <label for=\"%s\" class=\"block text-sm font-medium text-gray-700\">%s%s</label>" +
        "  <div class=\"relative\">" +
        "    %s" +
        "    <select id=\"%s\" name=\"%s\" %s" +
        "            class=\"w-full pl-%s pr-10 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200 bg-white appearance-none\">" +
        "      %s" +
        "    </select>" +
        "    <div class=\"absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none\">" +
        "      <svg class=\"w-5 h-5 text-gray-400\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\">" +
        "        <path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M19 9l-7 7-7-7\"/>" +
        "      </svg>" +
        "    </div>" +
        "  </div>" +
        "</div>",
        id, label, required ? " <span class=\"text-red-500\">*</span>" : "",
        icon != null ? String.format("<div class=\"absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none z-10\">%s</div>", icon) : "",
        id, name, required ? "required" : "",
        icon != null ? "10" : "4",
        optionsHtml.toString()
    );
}
%>

<%-- Button Component --%>
<%!
public String renderButton(String type, String text, String variant, String size, String icon, String onclick) {
    String baseClasses = "inline-flex items-center justify-center font-medium rounded-lg transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2";
    
    String variantClasses = "";
    switch (variant) {
        case "primary":
            variantClasses = "bg-indigo-600 hover:bg-indigo-700 text-white focus:ring-indigo-500 shadow-sm hover:shadow-md";
            break;
        case "success":
            variantClasses = "bg-green-600 hover:bg-green-700 text-white focus:ring-green-500 shadow-sm hover:shadow-md";
            break;
        case "danger":
            variantClasses = "bg-red-600 hover:bg-red-700 text-white focus:ring-red-500 shadow-sm hover:shadow-md";
            break;
        case "secondary":
            variantClasses = "bg-gray-600 hover:bg-gray-700 text-white focus:ring-gray-500 shadow-sm hover:shadow-md";
            break;
        case "outline":
            variantClasses = "border border-gray-300 bg-white hover:bg-gray-50 text-gray-700 focus:ring-indigo-500";
            break;
    }
    
    String sizeClasses = "";
    switch (size) {
        case "sm":
            sizeClasses = "px-3 py-2 text-sm";
            break;
        case "lg":
            sizeClasses = "px-6 py-3 text-base";
            break;
        default:
            sizeClasses = "px-4 py-2.5 text-sm";
    }
    
    String iconHtml = icon != null ? String.format("<span class=\"mr-2\">%s</span>", icon) : "";
    String onclickAttr = onclick != null ? String.format("onclick=\"%s\"", onclick) : "";
    
    return String.format(
        "<button type=\"%s\" class=\"%s %s %s\" %s>%s%s</button>",
        type, baseClasses, variantClasses, sizeClasses, onclickAttr, iconHtml, text
    );
}
%>

<%-- Alert Component --%>
<%!
public String renderAlert(String message, String type) {
    String icon = "";
    String classes = "p-4 rounded-lg border flex items-start space-x-3";
    
    switch (type) {
        case "success":
            classes += " bg-green-50 border-green-200 text-green-800";
            icon = "<svg class=\"w-5 h-5 text-green-400 mt-0.5\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M5 13l4 4L19 7\"/></svg>";
            break;
        case "error":
            classes += " bg-red-50 border-red-200 text-red-800";
            icon = "<svg class=\"w-5 h-5 text-red-400 mt-0.5\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M6 18L18 6M6 6l12 12\"/></svg>";
            break;
        case "warning":
            classes += " bg-yellow-50 border-yellow-200 text-yellow-800";
            icon = "<svg class=\"w-5 h-5 text-yellow-400 mt-0.5\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z\"/></svg>";
            break;
        case "info":
            classes += " bg-blue-50 border-blue-200 text-blue-800";
            icon = "<svg class=\"w-5 h-5 text-blue-400 mt-0.5\" fill=\"none\" stroke=\"currentColor\" viewBox=\"0 0 24 24\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" stroke-width=\"2\" d=\"M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z\"/></svg>";
            break;
    }
    
    return String.format(
        "<div class=\"%s animate-fade-in-up\">%s<div>%s</div></div>",
        classes, icon, message
    );
}
%>

<%-- Card Component --%>
<%!
public String renderCard(String title, String content, String headerActions) {
    return String.format(
        "<div class=\"bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden\">" +
        "  <div class=\"px-6 py-4 border-b border-gray-200 bg-gray-50\">" +
        "    <div class=\"flex items-center justify-between\">" +
        "      <h3 class=\"text-lg font-semibold text-gray-900\">%s</h3>" +
        "      %s" +
        "    </div>" +
        "  </div>" +
        "  <div class=\"p-6\">%s</div>" +
        "</div>",
        title, headerActions != null ? headerActions : "", content
    );
}
%>