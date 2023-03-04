from conan import ConanFile
from conan.tools.cmake import CMakeDeps

class Requirements(ConanFile):
	settings = "os", "compiler", "build_type", "arch"
	generators = "CMakeDeps"
	"""
	# XLAB INTERANAL PYTHON BASE EXTENSION
	python_requires = "requirements/0.1@xlab/stable"
	python_requires_extend = "requirements.RequirementsBase"
	"""

	def requirements(self):
		# List all needed requirements
		self.requires("eigen/3.4.0")
	