SIZE_TO_PROPERTY_MAP = {
    'big': {
        'length': 80,
        'linestartchar': '#',
        'textstartchar': '#',
    },
    'small': {
        'length': 40,
        'linestartchar': '-',
        'textstartchar': '>',
    },
}

def get_heading(text, size='small'):
    props = SIZE_TO_PROPERTY_MAP[size] 
    line = props['linestartchar'] + '-' * (props['length'] - 1)

    content = f"{props['textstartchar']} {text}"

    return "\n".join([line, content, line])
