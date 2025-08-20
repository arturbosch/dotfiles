import os

from modules import Launcher, control_center, status_bar

from ignis import utils
from ignis.css_manager import CssInfoPath, CssManager

css_manager = CssManager.get_default()

css_manager.apply_css(
    CssInfoPath(
        name="main",
        compiler_function=lambda path: utils.sass_compile(path=path),
        path=os.path.join(utils.get_current_dir(), "style.scss"),
    )
)

# this will display bar on all monitors
for i in range(utils.get_n_monitors()):
    status_bar(i)

Launcher()
control_center()
